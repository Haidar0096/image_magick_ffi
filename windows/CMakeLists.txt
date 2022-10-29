# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "image_magick_ffi")
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accomodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")


# ImageMagick Dlls
if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    # 64 bits
    set(dir x64)
elseif (CMAKE_SIZEOF_VOID_P EQUAL 4)
    # 32 bits
    set(dir x86)
endif ()

if (Q8)
    if (HDRI)
        message("Using Q8-HDRI libs for ImageMagick")
        set(dir ${dir}/Q8-HDRI)
    else ()
        message("Using Q8 libs for ImageMagick")
        set(dir ${dir}/Q8)
    endif ()
elseif (Q16)
    if (HDRI)
        message("Using Q16-HDRI libs for ImageMagick")
        set(dir ${dir}/Q16-HDRI)
    else ()
        message("Using Q16 libs for ImageMagick")
        set(dir ${dir}/Q16)
    endif ()
else ()
    message("Neither Q8 nor Q16 is not defined, using Q8 (No HDRI) libs by default")
    set(dir ${dir}/Q8)
endif ()
file(GLOB IMAGEMAGICK_DLLS ${CMAKE_CURRENT_SOURCE_DIR}/../src/Dependencies/ImageMagick/${dir}/bin/*.dll)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(image_magick_ffi_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accomodate different builds.
  $<TARGET_FILE:image_magick_ffi>
  # ImageMagick dlls to be bundled with the app's executable
  ${IMAGEMAGICK_DLLS}
  PARENT_SCOPE
)
