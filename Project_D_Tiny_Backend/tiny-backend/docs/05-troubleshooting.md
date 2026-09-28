# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| LLVM 22 not found | Missing development package or wrong `llvm-config` | Install LLVM 22 dev files or set `LLVM_CONFIG` |
| Missing X86/RISCV LLVM symbols | LLVM lacks that target or static components are incomplete | Use an LLVM 22 build with both targets and reconfigure cleanly |
| `--target` rejected | Unsupported spelling | Use exactly `x86-64` or `riscv64` |
| RISC-V object works but executable linking fails | Cross compiler/sysroot is missing | Install `riscv64-linux-gnu-gcc` or pass a compatible `--cc` |
| Can't link soft-float with double-float | Object and RISC-V runtime use different ABIs | Rebuild this project; its RISC-V target should report `ABI: lp64d` |
| RISC-V executable will not run locally | x86-64 cannot execute RISC-V instructions | Use RISC-V hardware or QEMU with the matching runtime |
| Undefined reference to `main` | Module contains only library functions | Emit an object and link a caller, or add `main` |
| Other undefined reference | Missing runtime function/library | Inspect symbols and link the correct implementation |
| Unsupported instruction/intrinsic | Input IR is target-specific | Regenerate the IR for the chosen target |
| Output already exists | Deliberate overwrite protection | Choose a new name or remove the generated output |
| Unknown `--cpu` or `-O` | Those options are intentionally absent | Use `--target`; this project fixes generic CPUs and codegen at `None` |

For an independent comparison:

```bash
llc-22 examples/add.ll -filetype=obj \
  -mtriple=riscv64-unknown-linux-gnu -mcpu=generic-rv64 \
  -O0 -o out/llc-add-riscv64.o
```

The project itself does not invoke `llc`; it uses the equivalent LLVM library
APIs directly.
