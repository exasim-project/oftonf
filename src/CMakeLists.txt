find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

set(CLANG_TOOL_SRC
    main.cc
    utils/utils.cc
    actions/frontendaction.cc
    consumer/consumer.cc
    transformer/transformer.cc
    transformer/functioncalltransformer.cc
    finder/finder.cc
    finder/integervariablefinder.cc)

add_executable(clang-tool ${CLANG_TOOL_SRC})
target_include_directories(clang-tool PUBLIC ${LLVM_INCLUDE_DIRS}
                                             ${CLANG_INCLUDE_DIRS})
target_compile_definitions(clang-tool PUBLIC ${LLVM_DEFINITIONS})
target_link_libraries(
  clang-tool
  PUBLIC LLVMSupport
         clangTooling
         ${CLANG_LIBS}
         ${LLVM_LIBRARIES}
         ${LLVM_LIBS}
         ${LLVM_LIBS_CORE}
         ${LLVM_LDFLAGS})
