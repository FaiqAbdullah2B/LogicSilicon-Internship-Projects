# Basic IR optimization

Use `--optimize` when you want smaller, cleaner IR before AOT code generation:

```bash
./build/tiny-backend input.ll --optimize --emit=llvm -o optimized.ll
```

The pipeline is intentionally explicit instead of calling LLVM's full default
`-O2` pipeline. That makes every transformation visible in `src/Optimizer.cpp`.

| Pass | Typical transformation | Why it is included |
|---|---|---|
| `mem2reg` | Promotes local stack variables into SSA registers | Frontends commonly produce `alloca`, `load`, and `store` instructions |
| `instcombine` | Changes `x * 1` to `x` and folds constants | A broadly useful cleanup pass with easy-to-understand results |
| `reassociate` | Rearranges expressions such as additions | Exposes constants and repeated subexpressions to later passes |
| `GVN` | Reuses an already computed equivalent value | Demonstrates elimination of redundant computation |
| `simplify-cfg` | Removes constant branches and merges blocks | Produces simpler control flow after other passes change instructions |

It is worth running for release-like output or when the input comes directly
from a simple frontend. Leave it off while learning, debugging, or comparing
the generated IR instruction by instruction. LLVM's machine-code pipeline also
performs some target-level lowering and cleanup, but it does not make an
explicit IR pipeline redundant: IR passes can reason about the program before
it becomes target-specific machine instructions.
