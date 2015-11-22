cmake_minimum_required(VERSION 3.3)
 
project(headShadow)
 
add_definitions(-DMSW)
 
set(SRC headShadow.c)
 
include_directories("C:/Users/Andrea/PureData/pd/src")
link_directories("C:/Users/Andrea/PureData/pd/bin")
 
add_library(headShadow SHARED ${SRC} headShadow.def)
 
set_target_properties(headShadow PROPERTIES LINKER_LANGUAGE CXX)

target_link_libraries (headShadow pd)