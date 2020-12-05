import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whoisit/screens/result_view.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  File _image;
  List _output;

  final picker = ImagePicker();

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Tflite.close();
  }

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('TFLITE EXPERIMENT'),
            RaisedButton(
              onPressed: () async {
                await pickImage();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ResultPage(
                              image: _image,
                              output: _output,
                            )));
              },
              child: Text('Take a Photo'),
            ),
            RaisedButton(
              onPressed: () async {
                await pickGalleryImage();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ResultPage(
                              image: _image,
                              output: _output,
                            )));
              },
              child: Text('Choose a Photo from Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
