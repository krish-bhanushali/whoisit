import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:whoisit/screens/answer_view.dart';
import 'package:whoisit/network/request_api.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;
  bool isPictureTaken = false;
  List _output;
  File _image;
  bool isFromGallery = false;

  RequestFacts randomfacts = RequestFacts();

  void fetchfacts() async {
    await randomfacts.getCatData();
    await randomfacts.getDogData();
  }

  final picker = ImagePicker();

  classifyImage({File image, String imagePathMy, bool isGallery}) async {
    String imagePath = isGallery ? image.path : imagePathMy;
    var output = await Tflite.runModelOnImage(
        path: isGallery ? image.path : imagePath,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    // 3
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    controller.addListener(() {
      // 5
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    // 6
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchfacts();
    loadModel().then((value) {
      setState(() {});
    });
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          // 2
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      } else {
        print("No camera available");
      }
    }).catchError((err) {
      // 3
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: isPictureTaken
                ? Container(
                    child: Image.file(File(imagePath)),
                  )
                : CameraPreview(controller)),
      ),
    );
  }

  void _onCapturePressed(context) async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // 2
      await controller.takePicture(path);
      imagePath = path;
      setState(() {
        isPictureTaken = true;
      });
      // 3

    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    Tflite.close();
  }

  void pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        isPictureTaken = false;
      });
    }
    setState(() {
      _image = File(image.path);
    });
    setState(() {
      isFromGallery = true;
      isPictureTaken = true;
      imagePath = image.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50.0,
          ),
          Container(
            child: _cameraPreviewWidget(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(Icons.photo_album),
                  onPressed: () {
                    pickGalleryImage();
                  }),
              isPictureTaken
                  ? Container(
                      child: IconButton(
                          icon: Icon(Icons.scanner_outlined),
                          onPressed: () async {
                            if (isFromGallery) {
                              await classifyImage(
                                  image: _image,
                                  isGallery: true,
                                  imagePathMy: null);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AnswerPage(
                                            isGallery: true,
                                            imagePath: _image,
                                            output: _output,
                                          )));
                            } else {
                              await classifyImage(
                                  image: null,
                                  isGallery: false,
                                  imagePathMy: imagePath);
                              MaterialPageRoute(
                                  builder: (_) => AnswerPage(
                                        isGallery: false,
                                        imagePath: imagePath,
                                        output: _output,
                                      ));
                            }

                            print(_output);
                          }),
                    )
                  : Container(),
              isPictureTaken
                  ? IconButton(
                      icon: Icon(Icons.refresh_outlined),
                      onPressed: () {
                        setState(() {
                          isPictureTaken = false;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () {
                        _onCapturePressed(context);
                      }),
            ],
          )
        ],
      ),
    );
  }
}
