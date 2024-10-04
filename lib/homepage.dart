import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class TextExtract extends StatefulWidget {
  const TextExtract({super.key});

  @override
  State<TextExtract> createState() => _TextExtractState();
}

class _TextExtractState extends State<TextExtract> {
  File? _image;
  String text='';

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future textRecognition(File img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    setState(() {
      text = recognizedText.text;
    });
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text Recognition')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey,
                child: Center(
                    child: _image == null
                        ? const Icon(Icons.add_a_photo, size: 60)
                        : Image.file(_image!)),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera).then((value) {
                      if (_image != null) {
                        textRecognition(_image!);
                      }
                    });
                  },
                  child: Text('Image From Camera'),
                ),
              ),
               SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery).then((value) {
                      if (_image != null) {
                          textRecognition(_image!);
                      }
                    });
                  },
                  child: Text('Image From Gallary'),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),)
              )
            ],
          ),
        ),
      ),
    );
  }
}