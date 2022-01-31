import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class readMeater extends StatefulWidget {
  const readMeater({Key? key}) : super(key: key);

  @override
  _readMeaterState createState() => _readMeaterState();
}

class _readMeaterState extends State<readMeater> {
  String imagePath = "asd";
  late File myImagePath;
  String finalText = ' ';
  bool isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              color: Colors.teal,
              child: isLoaded
                  ? Image.file(
                      myImagePath,
                      fit: BoxFit.fill,
                    )
                  : Text("This is image section "),
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      getImage();

                      Future.delayed(Duration(seconds: 5), () {
                        getText(imagePath);
                      });
                    },
                    child: Text(
                      "Pick Image",
                      style: GoogleFonts.aBeeZee(
                        fontSize: 30,
                      ),
                    ))),
            Text(
              finalText != null ? finalText : "This is my text",
              style: GoogleFonts.aBeeZee(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText _reconizedText =
        await textDetector.processImage(inputImage);

    for (TextBlock block in _reconizedText.blocks) {
      for (TextLine textLine in block.lines) {
        for (TextElement textElement in textLine.elements) {
          setState(() {
            finalText = finalText + " " + textElement.text;
          });
        }

        finalText = finalText + '\n';
      }
    }
  }

  // this is for getting the image form the gallery
  void getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      myImagePath = File(image!.path);
      isLoaded = true;
      imagePath = image.path.toString();
    });
  }
}
