cmake_minimum_required(VERSION 3.20)
project(assignment-1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(VTK REQUIRED COMPONENTS
    CommonCore
    CommonDataModel
    FiltersSources
    InteractionStyle
    IOImport
    RenderingCore
    RenderingOpenGL2
)

add_executable(assignment-1 main.cpp)
target_link_libraries(IPGlobe PRIVATE ${VTK_LIBRARIES})

vtk_module_autoinit(
    TARGETS assignment-1
    MODULES ${VTK_LIBRARIES}
)