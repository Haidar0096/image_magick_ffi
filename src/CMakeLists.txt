# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(image_magick_ffi_library VERSION 0.0.1 LANGUAGES C)

add_library(image_magick_ffi SHARED
  "image_magick_ffi.c"
)

set_target_properties(image_magick_ffi PROPERTIES
  PUBLIC_HEADER image_magick_ffi.h
  OUTPUT_NAME "image_magick_ffi"
)

target_compile_definitions(image_magick_ffi PUBLIC DART_SHARED_LIB)
