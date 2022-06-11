import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:famistory/services/service.dart';
import 'package:famistory/widgets/widgets.dart';

class CreatePage extends StatelessWidget {
  CreatePage({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: lightYellow,
            ),
            SingleChildScrollView(
              child: Column(
                children: [        
                  SizedBox(height: 100.h,),
                  Text("加入/建立家族", style: largeTextStyle,),
                  SizedBox(height: 100.h,),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OneTextInputField(title: "加入家族", controller: _controller,),
                      SizedBox(height: 20.h,),
                      RoundedElevatedButton(
                        onPressed: () async {
                          // TODO:
                          // 1. fetch group information from backend
                          // 2. checkout whether or not existing a group match the code
                          // 3. redirect to new page for asking join to the group if exists
                          
                          final url = Uri.parse("http://140.116.245.146:8000/group/fid/${_controller.text}");
                          final response = await http.get(url);

                          if (response.statusCode == 200) {
                            final res = jsonDecode(utf8.decode(response.bodyBytes));
                            if (res["status"] == "OK") {
                              _controller.clear();
                              Future.delayed(
                                const Duration(milliseconds: 10), () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AskForJoinPage(
                                        photo: res["family"]["image"], fname: res["family"]["fname"]
                                      )
                                    )
                                  );
                                }
                              );
                            }
                            else {
                              Future.delayed(
                                const Duration(milliseconds: 10), () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(res["status"]),
                                      action: SnackBarAction(onPressed: () {}, label: "OK",),
                                    ),
                                  );
                                });
                            }
                          }
                        },
                        backgroundColor: yellow,
                        child: Text("確認", style: smallTextStyle,),
                      ),
                    ],
                  ),
                  SizedBox(height: 80.h,),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("還沒建立家族嗎？", style: smallTextStyle,),
                      SizedBox(width: 20.w,),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CreateGroupPage()
                            ),
                          );
                        },
                        child: Text(
                          "建立家族",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: lightBlack,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({ Key? key }) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _controller = TextEditingController();
  String? _image;
  String _code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(color: lightYellow,),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50.h,),
                  Text("建立家族", style: largeTextStyle,),
                  SizedBox(height: 50.h,),
                  // image pre-view
                  Container(
                    child: _image != null
                      ? Image.file(io.File(_image!))
                      : Icon(Icons.photo_size_select_actual_rounded, size: 201.w, color: yellow,),
                  ),
                  RoundedElevatedButtonWithBorder(
                    onPressed: () async {
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
                    },
                    backgroundColor: Colors.white,
                    borderColor: yellow,
                    child: Text("上傳家族圖片", style: TextStyle(fontSize: 17.sp, color: Colors.black,),),
                  ),
                  SizedBox(height: 20.h,),
                  OneTextInputField(title: "家族名稱", controller: _controller,),
                  SizedBox(height: 50.h,),

                  RoundedRectElevatedButton(
                    backgroundColor: yellow,
                    onPressed: () async {
                      final url = Uri.parse("http://140.116.245.146:8000/group");
                      final request = http.MultipartRequest("POST", url);
                      request.fields["uid"] = "12345678";
                      request.fields["fname"] = _controller.text;
                      request.fields["fcnt"] = "1";
                      request.files.add(await http.MultipartFile.fromPath("photo", _image!));
                      
                      request.send().then((response) async {
                        final decodedResponse = jsonDecode(await response.stream.bytesToString());
                        _code = decodedResponse["code"];
                        Future.delayed(const Duration(microseconds: 10), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateSuccessfullyPage(code: _code),
                            ),
                          );
                        });
                      });
                    },
                    radius: 10.r,
                    fixedSize: Size(130.w, 40.h),
                    child: Text("建立家族", style: TextStyle(fontSize: 17.sp, color: Colors.black),),
                  ),
                  SizedBox(height: 10.h,),
                  const CancelTextButton(text: "取消",),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AskForJoinPage extends StatelessWidget {
  const AskForJoinPage({
    Key? key,
    required this.photo,
    required this.fname
  }) : super(key: key);

  final String photo;
  final String fname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(color: lightYellow,),
            Column(
              children: [
                SizedBox(height: 100.h,),
                Text("加入/建立家族", style: largeTextStyle,),
                SizedBox(height: 50.h,),

                // TODO: fetched image from backend
                Image.memory(
                      base64Decode(photo),
                      width: 164.w,
                      height: 164.w,
                    ),
                // Image.asset("assets/images/avatar.png", width: 164.w, height: 164.w,),
                SizedBox(height: 30.h,),
                // TODO: fetched group name from backend
                Text(fname, style: largeTextStyle,),
                // Text("我們這一家", style: largeTextStyle,),

                SizedBox(height: 50.h,),
                RoundedElevatedButton(
                  onPressed: () {
                    // TODO: Update group table
                    
                  },
                  backgroundColor: yellow,
                  fixedSize: Size(85.w, 27.h),
                  child: Text("加入", style: smallTextStyle,),
                ),
                SizedBox(height: 50.h,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("弄錯了嗎？", style: smallTextStyle,),
                    SizedBox(width: 20.w,),
                    InkWell(
                      child: Text(
                        "重新搜尋",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: 17.sp,
                          decoration: TextDecoration.underline
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CreateSuccessfullyPage extends StatelessWidget {
  const CreateSuccessfullyPage({
    Key? key,
    required this.code
  }) : super(key: key);

  final String code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: lightYellow,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 348.w,
                height: 221.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0XFFFFBA7A),
                        Color(0xFFFFDB5A),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: kElevationToShadow[4],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("恭喜創辦成功！使用邀請碼", style: smallTextStyle,),
                      Text("來邀請其他人吧！", style: smallTextStyle,),
                      SizedBox(height: 20.h,),
                      RoundedElevatedButton(
                        onPressed: () {
                          Copy2Clipboard(context, code);
                        },
                        fixedSize: Size(206.w, 40.h,),
                        elevated: false,
                        backgroundColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "邀請碼: $code",
                              style: smallTextStyle,
                            ),
                            const ImageIcon(AssetImage("assets/images/Icon-Artwork.png"), color: lightBlack,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h,),
              RoundedElevatedButton(
                onPressed: () {
                  // Add routeAndNavigatorSettings in PersistentBottomNavBarItem
                  // dit the trick
                  Navigator.popUntil(context, ModalRoute.withName("/info"));
                },
                backgroundColor: yellow,
                fixedSize: Size(178.w, 54.h,),
                child: Text("我知道了", style: largeTextStyle,),
              ),
            ],
          ),
        ],
      ),      
    );
  }
}