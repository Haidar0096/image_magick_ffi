# ImageMagickFFi Plugin
This plugin brings to you the imagemagick C/C++ library to use with dart.
- Feel native, interact with the underlying image magick C api just as you used to do in C (not with pointers, of course :P), see the #Usage below for more insights.

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
```dart
  // reads an image, then writes it in jpeg format
  Future<String?> _handlePress() async {
    try{
      MagickWand.magickWandGenesis(); // initialize the magick wand environment
      MagickWand wand = MagickWand.newMagickWand(); // create a new wand, which can be used to manipulate images
      wand.magickReadImage(_inputFile!.path); // read an image into the wand
      String inputFileNameWithoutExtension = _inputFile!.path.split('\\').last.split('.').first; // get input image name without extension
      wand.magickWriteImage("${outputDirectory!.path}\\out_${inputFileNameWithoutExtension}.jpeg"); // write image
      String error = wand.magickGetException().description; // get error, if any
      wand.destroyMagickWand(); // free resources used by the wand
      MagickWand.magickWandTerminus(); // terminate the magick wand environment
      return error.isEmpty ? null : error; // return error, if any
    }
    catch(e){
      return e.toString();
    }
  }
  ```
For more info, have a look at the example app in this repo.