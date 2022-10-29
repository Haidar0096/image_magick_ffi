// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_api;
import 'package:image_magick_ffi/image_magick_ffi.dart' as magick_ffi;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _inputFile;
  Directory? outputDirectory;
  int _outputImageWidth = 800;
  int _outputImageHeight = 600;

  TextEditingController outputImageWidthController = TextEditingController();
  TextEditingController outputImageHeightController = TextEditingController();

  String? operationError;

  @override
  dispose() {
    outputImageWidthController.dispose();
    outputImageHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_inputFile != null)
                        Image.file(
                          _inputFile!,
                          width: MediaQuery.of(context).size.width/2,
                          height: MediaQuery.of(context).size.height/3,
                        ),
                      Text('input file: ${_inputFile?.path}'),
                      Text('output directory: ${outputDirectory?.path}'),
                      Text('output image width: $_outputImageWidth'),
                      Text('output image height: $_outputImageHeight'),
                      Text('operation error: $operationError'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final filePickerResult =
                          await FilePicker.platform.pickFiles(allowedExtensions: ['jpg', 'jpeg', 'png'], type: FileType.custom);
                          if (filePickerResult != null) {
                            setState(() {
                              _inputFile = File(filePickerResult.files[0].path!);
                            });
                          }
                        },
                        child: const Text('pick input image'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final directoryPickerResult = await FilePicker.platform.getDirectoryPath();
                          if (directoryPickerResult != null) {
                            setState(() {
                              outputDirectory = Directory(directoryPickerResult);
                            });
                          }
                        },
                        child: const Text('pick output directory'),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'width',
                              ),
                              controller: outputImageWidthController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _outputImageWidth = int.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'height',
                              ),
                              controller: outputImageHeightController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _outputImageHeight = int.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_inputFile == null) {
                            setState(() {
                              operationError = 'input file is null';
                            });
                            return;
                          }
                          if (outputDirectory == null) {
                            setState(() {
                              operationError = 'output directory is null';
                            });
                            return;
                          }
                          if (_outputImageWidth <= 0) {
                            setState(() {
                              operationError = 'output image width is invalid';
                            });
                            return;
                          }
                          if (_outputImageHeight <= 0) {
                            setState(() {
                              operationError = 'output image height is invalid';
                            });
                            return;
                          }
                          // request permission if not granted
                          if (!await Permission.storage.request().isGranted) {
                            setState(() {
                              operationError = 'storage permission is not granted';
                            });
                            return;
                          }
                          final stopwatch = Stopwatch()..start();
                          operationError = await _resize();
                          stopwatch.stop();
                          print("resize time: ${stopwatch.elapsedMilliseconds}ms");
                          setState(() {});
                        },
                        child: const Text('resize image'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  Future<String?> _resize() async {
    return await magick_ffi.resize(
      inputFilePath: _inputFile!.path,
      outputFilePath: '${outputDirectory!.path}${Platform.pathSeparator}output.${_inputFile!.path.split('.').last}',
      width: _outputImageWidth,
      height: _outputImageHeight,
    );
  }

// Future<void> _slowResize() async {
//   var image = image_api.decodeImage(_inputFile.readAsBytesSync())!;
//   var resizedImage = image_api.copyResize(image, width: _outputImageWidth, height: _outputImageHeight);
//   await _slowApiOutputFile.writeAsBytes(image_api.encodePng(resizedImage, level: 2 ));
// }
}
