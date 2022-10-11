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

# ImageMagick
if(WIN32)
    add_definitions( -DMAGICKCORE_QUANTUM_DEPTH=16 )
    add_definitions( -DMAGICKCORE_HDRI_ENABLE=0 )

    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/include)

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        # 64 bits
        set(libDir x64)
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        # 32 bits
        set(libDir x86)
    endif()

    target_link_directories(image_magick_ffi PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/lib/${libDir})

    file(GLOB IMAGEMAGICK_LIBS ${CMAKE_CURRENT_SOURCE_DIR}/Dependencies/ImageMagick/lib/${libDir}/*.lib)
    target_link_libraries(image_magick_ffi
            "${IMAGEMAGICK_LIBS}"
            )
endif()