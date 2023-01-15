import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textee/button.dart';

void main() {
  runApp(MaterialApp(
    title: 'Textee',
    home: MyHomePage(),
  ),);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  String result = '';
  late ImagePicker imagePicker;

  dynamic textRecognizer;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();

    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  _imgFromCamera() async {
    XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  _imgFromGallery() async {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    setState(() {
      _image = image;
      if (_image != null) {
        doTextRecognition();
      }
    });
  }

  doTextRecognition() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    //This method can also be used to get the text

    // String text = recognizedText.text;
    // setState(() {
    //   result = text;
    // });
    for (TextBlock block in recognizedText.blocks) {
      final Rect rect = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints.cast<Offset>();
      final String text = block.text;
      final List<String> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          result+=element.text+" ";
        }
        result+="\n";
      }
      result+="\n";
    }
    setState(() {
      result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff4338CA),
          leading: null,
          title: const Text('Textee'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              Center(
                child: GradientButtonNew(
                  text: 'Select from Gallery',
                  onPressed: () {
                    _imgFromGallery();
                  },
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Center(
                child: GradientButtonNew(
                  text: 'Take a Picture',
                  onPressed: () {
                    _imgFromCamera();
                  },
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
