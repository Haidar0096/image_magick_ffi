# ImageMagickFFi Plugin
This plugin brings to you the ImageMagick C/C++ library to use with dart.
## Feel native
Interact with the underlying ImageMagick C api just as you used to do in C (not with pointers, of course :P).

See the #Usage section below for more insights.

# Install
`image_magick_ffi: <latest_version>`

# Setup
- Currently there are 4 variants of the ImageMagick library that come with this plugin: Q8, Q16, Q8-HDRI, and Q16-HDRI.
- You can choose which one you want to use.
- Your decision must be made at the build-time (not runtime) of your project.
- No need to worry about the files of other variants that you didn't choose in the previous step, only the files of the variant you had chosen will be bundled with your app when you build your app.
- #### Windows
  - Windows x64 (32 bits) and window x86 (32 bits) are both supported.
  - To choose one of the variants add this to your `windows/CMakeLists.txt` file:
    ```
    # Use ImageMagick with Q8 and HDRI enabled.
    set(Q8 1)
    set(HDRI 1)
    ```
  **Note**:
  - Do not try to `set(Q8 1)` and `set(Q16 1)` at the same time, or an error will occur.
  - If you don't set any configuration then by default "Q8-No HDRI" will be used.
  - Make sure you add the snippet above before this line `include(flutter/generated_plugins.cmake)`
- #### Android
  Currently only arm64-v8a (64 bits) is supported. If you want to help add support to armeabi-v7a (32 bits), have a look [here](https://github.com/MolotovCherry/Android-ImageMagick7/discussions/95).
  
  To choose one of the variants add this to your **`android/build.gradle`** file as a top-level statement:
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
  Your contributions to provide the binaries are welcomed :)
- #### IOS
  Your contributions to provide the binaries are welcomed :)

# Usage
```dart
  import 'package:image_magick_ffi/image_magick_ffi.dart' as im;
  
  // ...
  @override
  void initState() {
    im.initialize(); // initialize the plugin (can also be done before `runApp`)
    wand = im.MagickWand.newMagickWand(); // create a MagickWand to edit images
    super.initState();
  }
  // ...

// reads an image, then writes it in jpeg format
Future<String?> _handlePress() async {
  try {
    // set a callback to be called while the image is being processed
    await _wand.magickSetProgressMonitor(
      progressMonitorFunction,
      {
        'myName': 'fayruz',
        'myList': [1, 2, 3],
      },
    );

    await _wand.magickReadImage(_inputFile!.path);

    final String ps = Platform.pathSeparator;
    String inputFileNameWithoutExtension = _inputFile!.path.split(ps).last.split('.').first;
    await _wand.magickWriteImage(
            "${_outputDirectory!.path}${ps}out_$inputFileNameWithoutExtension.png"); // write the image to a file in the png format
    im.MagickGetExceptionResult e = _wand.magickGetException(); // get the exception if any
    if (e.severity != im.ExceptionType.UndefinedException) {
      throw e.description;
    }
    return null;
  } catch (e) {
    return e.toString();
  }
}

  // ...
  @override
  dispose() {
    wand.destroyMagickWand(); // we are done with the wand
    im.dispose(); // we are done with the plugin
    super.dispose();
  }
  // ...
```
- For more info about code usage, have a look at the example app in this repo.