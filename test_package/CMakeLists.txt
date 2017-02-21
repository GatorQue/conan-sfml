project(TestPackage)
cmake_minimum_required(VERSION 2.8)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
CONAN_BASIC_SETUP()

find_package("SFML")

if(SFML_FOUND)
    add_executable(testpkg testpkg.cpp)
    include_directories(${SFML_INCLUDE_DIRS})
    target_link_libraries(testpkg ${SFML_LIBRARIES})
else()
    message(FATAL_ERROR "SFML not found")
endif()
