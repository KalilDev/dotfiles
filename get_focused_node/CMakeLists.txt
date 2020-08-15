cmake_minimum_required (VERSION 3.11)
project (GET_FOCUSED_NODE)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_FLAGS "-Wall -Wextra")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

add_executable (getFocusedNode main.cpp)

target_include_directories(getFocusedNode
    PUBLIC 
        $<INSTALL_INTERFACE:include>    
        ${Boost_INCLUDE_DIRS}
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_compile_options(getFocusedNode PRIVATE -Werror)
target_compile_features(getFocusedNode PRIVATE cxx_std_20)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(nlohmann_json 3.2.0 REQUIRED)
find_package(Boost 1.72 REQUIRED)

set(CMAKE_CXX_FLAGS "-lboost_program_options")
target_link_libraries(getFocusedNode PRIVATE ${Boost_LIBRARIES} nlohmann_json::nlohmann_json)



#target_link_libraries (getFocusedNode LINK_PUBLIC FocusedNodeLib)
