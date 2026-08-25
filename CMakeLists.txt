cmake_minimum_required(VERSION 3.22)
project(test-pickle VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Boost REQUIRED COMPONENTS serialization)

add_executable(test-pickle testpickle.cpp)
target_link_libraries(test-pickle PRIVATE Boost::serialization)

add_custom_target(run-test-pickle
    COMMAND test-pickle
    DEPENDS test-pickle
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
)
