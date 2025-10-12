# User-defined CMake flags for Flutter Linux build
# This file is sourced during the CMake configuration

# Disable deprecated literal operator warnings as errors
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-error=deprecated-literal-operator")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-error=deprecated-literal-operator")

message(STATUS "Applied user CMake flags to suppress deprecated literal operator warnings")