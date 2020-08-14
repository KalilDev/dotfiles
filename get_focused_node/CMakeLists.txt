cmake_minimum_required (VERSION 3.11)
project (GET_FOCUSED_NODE)

add_executable (getFocusedNode main.cpp)

target_include_directories(getFocusedNode
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_options(getFocusedNode PRIVATE -Werror)
target_compile_features(getFocusedNode PRIVATE cxx_std_11)


find_package(nlohmann_json 3.2.0 REQUIRED)
find_package(Boost 1.72 REQUIRED)

target_link_libraries(getFocusedNode PRIVATE Boost::boost nlohmann_json::nlohmann_json)



#target_link_libraries (getFocusedNode LINK_PUBLIC FocusedNodeLib)
