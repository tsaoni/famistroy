import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../main.dart';
import '../widgets/widgets.dart';


final String photo = "assets/images/personnal.png";

class UploadPage extends StatefulWidget {
    const UploadPage({required this.uid, Key? key}) : super(key: key);
    final String uid;
    @override
    UploadPageState createState() {
        return UploadPageState();
    }
}

class UploadPageState extends State<UploadPage> {

    final _formKey = GlobalKey<FormState>();
    String _button_word = "上傳";
    bool _text_visible = false;
    String? _image;

    @override
    Widget build(BuildContext context) {
        return Stack(
          children: [
            Container(color: const Color.fromARGB(51, 255, 220, 107)),
            Scaffold(
              body: Center(
                  child: Column(
                      children: [
                          const SizedBox(height: 235,),
                          SizedBox(
                              width: 247.w,
                              height: 247.h,
                              child: _image != null ? Image.file(io.File(_image!)) : Image.asset(photo)
                          ),
                          SizedBox(
                              height: 150.h,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RoundedRectElevatedButton(
                                      backgroundColor: const Color(0xffffd66b),
                                      fixedSize: Size(150.w, 50.h),
                                      onPressed: () async {
                                        if(_button_word == "確認") {
                                          
                                          final url = Uri.parse("http://140.116.245.146:8000/upload/personal-image");
                                          final request = http.MultipartRequest("POST", url);
                                          request.fields["uid"] = widget.uid;
                                          request.files.add(await http.MultipartFile.fromPath("avatar", _image!));
                                          request.send().then((response) async {
                                            final res = jsonDecode(await response.stream.bytesToString());
                                            print(res);
                                          });

                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (BuildContext context) => const MainPage()),
                                            ModalRoute.withName('/card'),
                                          );
                                        } else {
                                          final ImagePicker picker = ImagePicker();
                                          final imageFromGallery = 
                                              await picker.pickImage(source: ImageSource.gallery);
                                          CroppedFile? croppedImage = await ImageCropper().cropImage(
                                            sourcePath: imageFromGallery!.path,
                                            aspectRatioPresets: [
                                              CropAspectRatioPreset.square,
                                            ],
                                          );
                                          if (croppedImage != null) {
                                            setState(() {
                                              _image = croppedImage.path;
                                            });
                                          }
                                          setState((){
                                            _button_word = "確認";
                                            _text_visible = true;
                                          });
                                        }
                                      },
                                      child: Text(_button_word, style: smallTextStyle),
                                  ),
                              )
                          ),
                        SizedBox(
                            width: 200.w,
                            height: 50.h,
                            child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                    child: _text_visible? const Text('重新上傳'): const Text(''),
                                    onTap: () {
                                      setState(() {
                                        _button_word = "上傳";
                                        _image = null;
                                      });
                                      _text_visible = false;
                                    }
                                )
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 50.h,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                    child: const Text('略過'),
                                    onTap: () async {
                                      final url = Uri.parse("http://140.116.245.146:8000/upload/default-image");
                                      final response = await http.post(url,
                                        headers: {"Content-Type": "application/json"},
                                        body: jsonEncode({
                                          "id": widget.uid,
                                          "type": "users"
                                        })
                                      );

                                      if (response.statusCode == 200) {
                                        print(jsonDecode(utf8.decode(response.bodyBytes)));
                                      }
                                      else {
                                        throw Exception('Failed to upload data to server');
                                      }


                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (BuildContext context) => const MainPage()),
                                        ModalRoute.withName('/card'),
                                      );
                                    }
                                )
                            )
                        ),
                      ]
                  ),
              )
            )
        ]
        );
    }

}