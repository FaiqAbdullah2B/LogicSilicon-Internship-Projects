"""End-to-end tests of the real C++ executable; no third-party Python packages.

Run via ctest, or: python3 tests/integration.py build/tiny-backend examples --llvm-as=llvm-as-22
Each test uses fresh output files and checks externally observable behavior.
"""
import argparse
from pathlib import Path
import subprocess
import tempfile


def run(args, expected=0):
    result = subprocess.run([str(a) for a in args], text=True, capture_output=True)
    assert result.returncode == expected, (
        f"Command: {args}\nExpected {expected}, got {result.returncode}\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )
    return result


def elf_machine(path):
    data = path.read_bytes()
    assert data[:4] == b"\x7fELF", f"Not an ELF file: {path}"
    byte_order = "little" if data[5] == 1 else "big"
    return int.from_bytes(data[18:20], byte_order)


def elf_flags(path):
    data = path.read_bytes()
    assert data[:5] == b"\x7fELF\x02", f"Not a 64-bit ELF file: {path}"
    byte_order = "little" if data[5] == 1 else "big"
    return int.from_bytes(data[48:52], byte_order)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("backend", type=lambda p: Path(p).resolve())
    parser.add_argument("examples", type=lambda p: Path(p).resolve())
    parser.add_argument("--llvm-as", default="llvm-as-22")
    args = parser.parse_args()
    backend, examples = args.backend, args.examples
    checks = 0
    with tempfile.TemporaryDirectory(prefix="tiny backend test ") as temp:
        root = Path(temp)
        for name, status, stdout in [
            ("return42", 42, ""),
            ("hello", 0, "Hello from LLVM IR!\n"),
            ("sum", 55, ""),
        ]:
            exe = root / name
            run([backend, examples / f"{name}.ll", "-o", exe])
            assert run([exe], status).stdout == stdout
            checks += 1

        bitcode = root / "return42.bc"
        run([args.llvm_as, examples / "return42.ll", "-o", bitcode])
        exe = root / "from-bitcode"
        run([backend, bitcode, "-o", exe])
        run([exe], 42)
        checks += 1

        obj = root / "add.o"
        run([backend, examples / "add.ll", "--emit=obj", "-o", obj])
        assert elf_machine(obj) == 62  # EM_X86_64
        exe = root / "caller"
        run(["cc", examples / "caller.c", obj, "-o", exe])
        assert run([exe]).stdout == "add(19, 23) = 42\n"
        checks += 1

        assembly = root / "add.s"
        run([backend, examples / "add.ll", "--emit=asm", "-o", assembly])
        exe = root / "caller-from-asm"
        run(["cc", examples / "caller.c", assembly, "-o", exe])
        assert run([exe]).stdout == "add(19, 23) = 42\n"
        checks += 1

        ir = root / "printed.ll"
        run([backend, examples / "return42.ll", "--emit=llvm", "-o", ir])
        exe = root / "roundtrip"
        run([backend, ir, "-o", exe])
        run([exe], 42)
        checks += 1

        # IR output must preserve computations that an O2 pipeline would fold
        # or delete. Code generation can still lower/fold them internally.
        source = root / "preserve.ll"
        source.write_text("""define i32 @main() {
entry:
  %answer = add i32 19, 23
  %unused = mul i32 7, 9
  ret i32 %answer
}
""")
        preserved = root / "preserved.ll"
        run([backend, source, "--emit=llvm", "-o", preserved])
        text = preserved.read_text()
        for instruction in ["%answer = add i32 19, 23",
                            "%unused = mul i32 7, 9", "ret i32 %answer"]:
            assert instruction in text, text
        assert "target triple =" in text and "target datalayout =" in text
        exe = root / "preserved-program"
        run([backend, preserved, "-o", exe])
        run([exe], 42)
        checks += 1

        # The optional teaching pipeline should turn simple stack-based IR into
        # compact SSA and fold the result without changing program behavior.
        optimizable = root / "optimizable.ll"
        optimizable.write_text("""define i32 @main() {
entry:
  %slot = alloca i32
  store i32 40, ptr %slot
  %value = load i32, ptr %slot
  %sum = add i32 %value, 2
  %identity = mul i32 %sum, 1
  %condition = icmp eq i32 1, 1
  br i1 %condition, label %yes, label %no
yes:
  ret i32 %identity
no:
  ret i32 0
}
""")
        optimized = root / "optimized.ll"
        run([backend, optimizable, "--optimize", "--emit=llvm",
             "-o", optimized])
        optimized_text = optimized.read_text()
        assert "ret i32 42" in optimized_text
        for removed in ["alloca", "load", "store", " mul ", " br "]:
            assert removed not in optimized_text, optimized_text
        optimized_exe = root / "optimized-program"
        run([backend, optimizable, "--optimize", "-o", optimized_exe])
        run([optimized_exe], 42)
        checks += 1

        # Cross-compile the same target-neutral IR without running the result.
        riscv_obj = root / "add-riscv64.o"
        run([backend, examples / "add.ll", "--target=riscv64",
             "--emit=obj", "-o", riscv_obj])
        assert elf_machine(riscv_obj) == 243  # EM_RISCV
        assert (elf_flags(riscv_obj) & 0x6) == 0x4  # EF_RISCV_FLOAT_ABI_DOUBLE
        checks += 1

        riscv_asm = root / "add-riscv64.s"
        run([backend, examples / "add.ll", "--target=riscv64",
             "--emit=asm", "-o", riscv_asm])
        assert riscv_asm.stat().st_size > 0
        checks += 1

        # The D extension should lower float-to-double conversion in hardware,
        # rather than introducing the soft-float helper __extendsfdf2.
        float_ir = root / "riscv-float.ll"
        float_ir.write_text("""define double @widen(float %value) {
entry:
  %wide = fpext float %value to double
  ret double %wide
}
""")
        float_asm = root / "riscv-float.s"
        run([backend, float_ir, "--target=riscv64",
             "--emit=asm", "-o", float_asm])
        float_text = float_asm.read_text()
        assert "fcvt.d.s" in float_text
        assert "__extendsfdf2" not in float_text
        checks += 1

        # Existing target metadata is replaced by the command-line target.
        foreign = root / "foreign.ll"
        foreign.write_text('target triple = "aarch64-unknown-linux-gnu"\n'
                           'define i32 @main() { ret i32 0 }')
        retargeted = root / "retargeted.ll"
        run([backend, foreign, "--target=riscv64", "--emit=llvm",
             "-o", retargeted])
        assert 'target triple = "riscv64-unknown-linux-gnu"' in retargeted.read_text()
        checks += 1

        # Syntax error and valid syntax with an invalid dominance relationship.
        negative_inputs = {
            "syntax.ll": "this is not LLVM IR",
            "dominance.ll": '''define i32 @main() {
entry:
  br i1 true, label %left, label %right
left:
  %value = add i32 1, 2
  br label %right
right:
  ret i32 %value
}
''',
            "unresolved.ll": 'declare i32 @missing_function()\n'
                             'define i32 @main() { %v = call i32 @missing_function()\nret i32 %v }',
        }
        for name, contents in negative_inputs.items():
            path = root / name
            path.write_text(contents)
            run([backend, path, "-o", root / f"{name}.out"], 1)
            checks += 1
        run([backend, examples / "add.ll", "-o", root / "no-main"], 1)
        run([backend, root / "absent.ll", "-o", root / "absent"], 1)
        run([backend, examples / "hello.ll", "--cc=does-not-exist-tiny", "-o", root / "bad-driver"], 1)
        run([backend, examples / "hello.ll", "-o", root / "missing-dir" / "out"], 1)
        checks += 4

        sentinel = root / "existing"
        sentinel.write_text("keep me")
        run([backend, examples / "hello.ll", "-o", sentinel], 1)
        assert sentinel.read_text() == "keep me"
        checks += 1

        for option in ["--emit=bad", "--target=bad", "--cpu=native",
                       "-O0", "-O1", "-O2", "-O3"]:
            run([backend, examples / "hello.ll", option, "-o", root / "bad-option"], 1)
            checks += 1

        # The semicolon is an ordinary filename character, including at link time.
        exe = root / "hello ; literal filename"
        run([backend, examples / "hello.ll", "-o", exe])
        assert run([exe]).stdout == "Hello from LLVM IR!\n"
        checks += 1

        # Reject unsupported extensions even if their contents are valid IR.
        for name, contents in [
            ("input.mlir", "module { llvm.func @main() -> i32 }"),
            ("disguised.mlir", (examples / "return42.ll").read_text()),
            ("input.txt", (examples / "return42.ll").read_text()),
        ]:
            path = root / name
            path.write_text(contents)
            output = root / f"{name}.out"
            result = run([backend, path, "-o", output], 1)
            assert "Expected a .ll or .bc file" in result.stderr
            assert not output.exists()
            checks += 1

        # Renaming actual MLIR does not turn it into LLVM IR.
        renamed = root / "renamed.ll"
        renamed.write_text("module { llvm.func @main() -> i32 }")
        run([backend, renamed, "-o", root / "renamed.out"], 1)
        checks += 1
    print(f"PASS: {checks} end-to-end scenarios")


if __name__ == "__main__":
    main()
