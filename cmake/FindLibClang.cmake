if(NOT CLANG_ROOT)
  set(CLANG_ROOT $ENV{CLANG_ROOT})
endif()

if(NOT LLVM_CONFIG)
  set(LLVM_CONFIG $ENV{LLVM_CONFIG})
  if(NOT LLVM_CONFIG)
    set(llvm_config_names llvm-config)
    foreach(minor RANGE 9 1)
      list(APPEND llvm_config_names "llvm-config3${minor}"
           "llvm-config-3.${minor}" "llvm-config-mp-3.${minor}")
    endforeach()
    find_program(LLVM_CONFIG NAMES ${llvm_config_names})
  endif()
endif()

if(LLVM_CONFIG)
  message(STATUS "llvm-config found at: ${LLVM_CONFIG}")
else()
  message(FATAL_ERROR "Could NOT find llvm-config executable.")
endif()

if(NOT CLANG_CXXFLAGS)
  execute_process(
    COMMAND ${LLVM_CONFIG} --cxxflags
    OUTPUT_VARIABLE CLANG_CXXFLAGS
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT CLANG_CXXFLAGS)
    find_path(
      CLANG_CXXFLAGS_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT clang-c/Index.h
      HINTS ${CLANG_ROOT}/include
      NO_DEFAULT_PATH)
    if(NOT EXISTS ${CLANG_CXXFLAGS_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT})
      find_path(CLANG_CXXFLAGS clang-c/Index.h)
      if(NOT EXISTS ${CLANG_CXXFLAGS})
        message(
          FATAL_ERROR
            "Could NOT find clang include path. You can fix this by setting CLANG_CXXFLAGS in your shell or as a cmake variable."
        )
      endif()
    else()
      set(CLANG_CXXFLAGS ${CLANG_CXXFLAGS_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT})
    endif()
    set(CLANG_CXXFLAGS "-I${CLANG_CXXFLAGS}")
  endif()
endif()

if(NOT EXISTS ${CLANG_LIBDIR})
  execute_process(
    COMMAND ${LLVM_CONFIG} --libdir
    OUTPUT_VARIABLE CLANG_LIBDIR
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT EXISTS ${CLANG_LIBDIR})
    message(
      FATAL_ERROR
        "Could NOT find clang libdir. You can fix this by setting CLANG_LIBDIR in your shell or as a cmake variable."
    )
  endif()
endif()

if(NOT CLANG_LIBS)
  find_library(
    CLANG_LIB_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT
    NAMES clang libclang ${CLANG_ROOT}/lib ${CLANG_LIBDIR}
    NO_DEFAULT_PATH)
  if(NOT EXISTS ${CLANG_CLANG_LIB_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT})
    find_library(CLANG_LIBS NAMES clang libclang)
    if(NOT EXISTS ${CLANG_LIBS})
      set(CLANG_LIBS "-L${CLANG_LIBDIR}" "-lclang" "-Wl,-rpath,${CLANG_LIBDIR}")
    endif()
  else()
    set(CLANG_LIBS "${CLANG_LIB_HACK_CMAKECACHE_DOT_TEXT_BULLSHIT}")
  endif()
endif()

execute_process(
  COMMAND ${LLVM_CONFIG} --version
  OUTPUT_VARIABLE CLANG_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE)
message(
  "-- Using Clang ${CLANG_VERSION} from ${CLANG_LIBDIR} with LIBS ${CLANG_LIBS} and CXXFLAGS ${CLANG_CXXFLAGS}"
)
