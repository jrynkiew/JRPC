project (JRPC)
cmake_minimum_required(VERSION 3.10)

include_directories(BEFORE "external/glad/include")
include_directories(AFTER "external")
include_directories(${SDL2_INCLUDE_DIRS})

set(EXECUTABLE_OUTPUT_PATH "bin")

find_package(OpenGL REQUIRED)
find_package(SDL2 REQUIRED)

ADD_LIBRARY("glad" "external/glad/src/glad.c")

set(sources
    src/sdl.cpp
    external/glad/src/glad.c
    external/glad/include/glad/glad.h
)

add_executable(${CMAKE_PROJECT_NAME} ${sources})

target_link_libraries(glad -ldl)
target_link_libraries(${CMAKE_PROJECT_NAME} ${SDL2_LIBRARIES})
target_link_libraries(${CMAKE_PROJECT_NAME} ${OPENGL_gl_LIBRARY})
target_link_libraries(${CMAKE_PROJECT_NAME}
    "glad"
    )