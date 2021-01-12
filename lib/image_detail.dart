import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:io';
import 'dart:ui';
import 'dart:async';

import 'package:loko_moto_driver/screens/usernamest.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  _DetailScreenState createState() => new _DetailScreenState(imagePath);
}

String finalname = "";
String finalidnumber = "";


class _DetailScreenState extends State<DetailScreen> {

  _DetailScreenState(this.path);

  final String path;

  Size _imageSize;
  List<TextElement> _elements = [];
  String recognizedText = "Loading ...";

  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
    FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
    FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
    await textRecognizer.processImage(visionImage);

    String pattern = r'^-?[0-9]+$';

        //r"^[0-9]{9,13}$";
      //  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regEx = RegExp(pattern);

    String mailAddress = '';
    String name = "";

    String birthday = "";
    String finalbirthday = "";
    String idnumber = "";


    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {

        mailAddress += line.text + '\n';
        if(line.text.startsWith("Name")){
          name = line.text;
          finalname = name.replaceAll("Name ", "");

        } else if(line.text.startsWith("Date of Birth")){
          birthday = line.text;
          finalbirthday = birthday.replaceAll("Date of Birth", "");

        }else if(line.text.startsWith("ID NO")){
          idnumber = line.text;

          finalidnumber = idnumber.replaceAll(new RegExp(r'[^0-9]'), "");
        }

       /* for (TextElement element in line.elements) {
          _elements.add(element);
        }*/
      }
    }

    if (this.mounted) {
      setState(() {
        recognizedText = "FULL NAME: "+finalname+" ID NUMBER: "+ finalidnumber;
      });
    }
  }

  List<String> split(String string, String separator, {int max = 0}) {
    var result = List<String>();

    if (separator.isEmpty) {
      result.add(string);
      return result;
    }

    while (true) {
      var index = string.indexOf(separator, 0);
      if (index == -1 || (max > 0 && result.length >= max)) {
        result.add(string);
        break;
      }

      result.add(string.substring(0, index));
      string = string.substring(index + separator.length);
    }

    return result;
  }


  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details"),
      ),
      body: _imageSize != null
          ? Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: double.maxFinite,
              color: Colors.black,
              child: CustomPaint(
                foregroundPainter:
                TextDetectorPainter(_imageSize, _elements),
                child: AspectRatio(
                  aspectRatio: _imageSize.aspectRatio,
                  child: Image.file(
                    File(path),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              elevation: 8,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Identified ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: SingleChildScrollView(
                        child: Text(
                          recognizedText,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton.icon(
                        icon: Icon(Icons.arrow_forward_sharp),
                        label: Text("Click"),
                        onPressed: () async {
                          if (finalname != null && finalidnumber != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserNamePage(finalname, finalidnumber),
                              ),
                            );
                          }
                        },
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeWidth = 2.0;

    for (TextElement element in elements) {
      canvas.drawRect(scaleRect(element), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}