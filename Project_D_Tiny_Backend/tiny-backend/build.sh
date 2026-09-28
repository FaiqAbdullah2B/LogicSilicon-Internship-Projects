#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: bash build.sh [--test]"
  echo "Build the backend; --test also runs the integration tests."
  echo "For a custom LLVM 22 installation, set LLVM_CONFIG to its llvm-config path."
}

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 1
fi
run_tests=OFF
case "${1:-}" in
  "") ;;
  --test) run_tests=ON ;;
  --help|-h) usage; exit 0 ;;
  *) usage >&2; exit 1 ;;
esac

if ! command -v cmake >/dev/null 2>&1; then
  echo "CMake is missing. Install cmake, then run this script again." >&2
  exit 1
fi

# Support version-suffixed tools and distributions with an unsuffixed name.
llvm_config=${LLVM_CONFIG:-}
if [[ -z "$llvm_config" ]]; then
  for candidate in llvm-config-22 llvm-config /usr/lib/llvm-22/bin/llvm-config; do
    if command -v "$candidate" >/dev/null 2>&1; then
      version=$("$candidate" --version)
      if [[ "$version" == 22.* ]]; then
        llvm_config=$candidate
        break
      fi
    fi
  done
fi
if [[ -z "$llvm_config" ]] || ! command -v "$llvm_config" >/dev/null 2>&1; then
  echo "LLVM 22 development tools were not found. Install them or set LLVM_CONFIG." >&2
  exit 1
fi
version=$("$llvm_config" --version)
if [[ "$version" != 22.* ]]; then
  echo "LLVM 22.x is required; $llvm_config reports $version." >&2
  exit 1
fi

targets=$("$llvm_config" --targets-built)
for required_target in X86 RISCV; do
  if [[ " $targets " != *" $required_target "* ]]; then
    echo "LLVM 22 was built without the $required_target backend." >&2
    echo "Use an LLVM installation containing both X86 and RISCV targets." >&2
    exit 1
  fi
done

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
llvm_dir=$("$llvm_config" --cmakedir)

# Reuse an existing CMake generator. Prefer Ninja for a fresh build if present;
# otherwise CMake uses its default (normally Makefiles on Linux).
generator=()
if [[ ! -f "$project_dir/build/CMakeCache.txt" ]] && command -v ninja >/dev/null 2>&1; then
  generator=(-G Ninja)
fi
cmake -S "$project_dir" -B "$project_dir/build" "${generator[@]}" \
  "-DLLVM_DIR=$llvm_dir" -DCMAKE_BUILD_TYPE=Debug "-DBUILD_TESTING=$run_tests"
cmake --build "$project_dir/build" --parallel 2
if [[ "$run_tests" == ON ]]; then
  ctest --test-dir "$project_dir/build" --output-on-failure
fi
echo "Built: $project_dir/build/tiny-backend"
