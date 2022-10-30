# ImageMagickFFi Plugin
This plugin brings to you the imagemagick C/C++ library to use with dart.

# Install
`image_magick_ffi: <latest_version>`

# Setup
- Currently there are 4 variants of the imagemagick library that come with the plugin: Q8, Q16, Q8-HDRI, and Q16-HDRI.
- you can choose which one you want to use.
- Your decision must be made at buildtime (not runtime) since the versions are bundled as shared libraries.
- Only the version you use will be bundled with your app when you build your app.
- #### Windows
  Windows x64 (32 bits) and window x86 (32 bits) are both supported.
  To choose one of the variants add this to your `windows/CMakeLists.txt` file:
    ```
    # Use ImageMagick with Q8 and HDRI enabled.
    set(Q8 1)
    set(HDRI 1)
    ```
  Note:
  - Do not try to `set(Q8 1)` and `set(Q16 1)` at the same time, or undefined behaviour will occur.
  - If you don't set any configuration then by default "Q8-No HDRI" will be used.
  - Make sure you add the snippet above before this line `include(flutter/generated_plugins.cmake)`
- #### Android
  Currently only arm64-v8a (64 bits) is supported. If you want to help add support to armeabi-v7a (32 bits), have a look [here](https://github.com/MolotovCherry/Android-ImageMagick7/discussions/95).
  To choose one of the variants add this to your **`android/build.gradle`** file:
    ```
    // Use ImageMagick with Q16 and HDRI enabled.
    ext {
        Q16 = 1
        HDRI = 1
    }
    ```
- #### Linux
  Coming Soon
- #### Macos
  Your contributions to provide the binraires are welcomed :)
- #### Ios
  Your contributions to provide the binraires are welcomed :)

# Usage
 ```
 import 'package:image_magick_ffi/image_magick_ffi.dart' as magick_ffi;
   Future<String?> _resize() async {
    return await magick_ffi.resize(
      inputFilePath: "some/path",
      outputFilePath: "some/path",
      height: 800,
      width: 600,
    );
  }
 ```