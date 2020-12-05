import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whoisit/network/request_api.dart';

class AnswerPage extends StatefulWidget {
  final dynamic imagePath;
  final List output;
  final bool isGallery;

  const AnswerPage({Key key, this.imagePath, this.output, this.isGallery})
      : super(key: key);
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: ClipRRect(
              child: widget.isGallery
                  ? Image.file(widget.imagePath)
                  : Image.file(File(widget.imagePath)),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          widget.output[0]["confidence"] == 1.0
              ? Column(
                  children: [
                    Text('${widget.output[0]["label"]}'),
                    Column(
                      children: [
                        widget.output[0]["label"] == "Cat"
                            ? Container(
                                color: Colors.blueAccent,
                                child: Text(aCatFact),
                              )
                            : Container(
                                color: Colors.blueAccent,
                                child: Text(aDogFact),
                              )
                      ],
                    )
                  ],
                )
              : Text('Well Not Confident enough to answer that try again'),
        ],
      ),
    );
  }
}
