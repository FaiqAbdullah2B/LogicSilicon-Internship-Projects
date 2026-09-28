cmake_minimum_required(VERSION 3.20)
project(TinyBackend VERSION 1.4 LANGUAGES C CXX)

# Use one major version throughout: LLVM's C++ API is not version-stable.
find_package(LLVM REQUIRED CONFIG)
if(NOT LLVM_VERSION_MAJOR EQUAL 22)
  message(FATAL_ERROR "This teaching project requires LLVM 22.x")
endif()
message(STATUS "Using LLVM ${LLVM_PACKAGE_VERSION} from ${LLVM_DIR}")

add_executable(tiny-backend
  src/main.cpp
  src/Backend.cpp
  src/Input.cpp
  src/Linker.cpp
  src/Optimizer.cpp)
target_compile_features(tiny-backend PRIVATE cxx_std_17)
target_include_directories(tiny-backend SYSTEM PRIVATE ${LLVM_INCLUDE_DIRS})
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND "${LLVM_DEFINITIONS}")
target_compile_options(tiny-backend PRIVATE ${LLVM_DEFINITIONS_LIST})

# Match the LLVM installation's shared or static linking mode.
if(LLVM_LINK_LLVM_DYLIB)
  target_link_libraries(tiny-backend PRIVATE LLVM)
else()
  # Include both code generators when LLVM is installed as static libraries.
  llvm_map_components_to_libnames(TINY_LLVM_LIBS
    Core IRReader Support AsmParser Analysis Passes InstCombine ScalarOpts
    TransformUtils X86 RISCV)
  target_link_libraries(tiny-backend PRIVATE ${TINY_LLVM_LIBS})
endif()

option(BUILD_TESTING "Enable the Python integration tests" OFF)
include(CTest)
if(BUILD_TESTING)
  find_package(Python3 REQUIRED COMPONENTS Interpreter)
  add_test(NAME pipeline
    COMMAND ${Python3_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/tests/integration.py
      $<TARGET_FILE:tiny-backend> ${CMAKE_CURRENT_SOURCE_DIR}/examples
      "--llvm-as=${LLVM_TOOLS_BINARY_DIR}/llvm-as${CMAKE_EXECUTABLE_SUFFIX}")
endif()
