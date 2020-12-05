import 'dart:io';

import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final File image;
  final List output;

  const ResultPage({Key key, this.image, this.output}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              child: Image.file(widget.image),
            ),
            SizedBox(
              height: 40.0,
            ),
            widget.output != null ? Text('${widget.output[0]}') : Container()
          ],
        ),
      ),
    );
  }
}
