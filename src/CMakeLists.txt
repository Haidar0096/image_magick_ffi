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

################################### Dart Sdk Api ###################################
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/dart_sdk_api")
file(GLOB_RECURSE DART_SDK_API "${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/dart_sdk_api/*.c")
add_library(dart_sdk_api STATIC ${DART_SDK_API})
target_link_libraries(image_magick_ffi dart_sdk_api)
################################### Dart Sdk Api ###################################

################################### Json-C ###################################
include_directories("${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/json-c/include")
file(GLOB_RECURSE JSON_C "${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/json-c/*.c")
add_library(json-c STATIC ${JSON_C})
target_link_libraries(image_magick_ffi json-c)
################################### Json-C ###################################

################################### Image Magick ###################################
macro(setDir dir)
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
endmacro()

if (WIN32)
    if (CMAKE_SIZEOF_VOID_P EQUAL 8)
        # 64 bits
        set(dir x64)
    elseif (CMAKE_SIZEOF_VOID_P EQUAL 4)
        # 32 bits
        set(dir x86)
    endif ()

    setDir(${dir})

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/include)

    file(GLOB IMAGEMAGICK_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/lib/*.lib)
    target_link_libraries(image_magick_ffi ${IMAGEMAGICK_LIBS})

elseif (ANDROID)
    if (${ANDROID_ABI} STREQUAL "arm64-v8a")
        set(dir arm64-v8a)
    else ()
        message(FATAL_ERROR "Only arm64-v8a is supported for android at the moment")
    endif ()

    setDir(${dir})

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/include)

    # MagickCore
    add_library(magickcore SHARED IMPORTED)
    set_target_properties(magickcore PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/bin/libmagickcore-7.so)
    target_link_libraries(image_magick_ffi magickcore)

    # MagickWand
    add_library(magickwand SHARED IMPORTED)
    set_target_properties(magickwand PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/bin/libmagickwand-7.so)
    target_link_libraries(image_magick_ffi magickwand)

    # libomp
    add_library(omp SHARED IMPORTED)
    set_target_properties(omp PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/bin/libomp.so)
    target_link_libraries(image_magick_ffi omp)

    # libc++_shared
    add_library(cxx_shared SHARED IMPORTED)
    set_target_properties(cxx_shared PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/${dir}/bin/libc++_shared.so)
    target_link_libraries(image_magick_ffi cxx_shared)

    # android log lib
    find_library(log-lib log)
    target_link_libraries(image_magick_ffi ${log-lib})
endif ()
################################### Image Magick ###################################