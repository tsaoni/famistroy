import 'dart:io' as io;

import 'package:famistory/services/service.dart';
import 'package:famistory/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({ Key? key }) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
                        onPressed: () {
                          // TODO:
                          // 1. fetch group information from backend
                          // 2. checkout whether or not existing a group match the code
                          // 3. redirect to new page for asking join to the group if exists
                          if (true) {
                            _controller.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AskForJoinPage())
                            );
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
                      // TODO:
                      // pick image from gallery
                      final ImagePicker picker = ImagePicker();
                      final imageFromGallery = 
                          await picker.pickImage(source: ImageSource.gallery);
                      CroppedFile? croppedImage = await ImageCropper().cropImage(
                        sourcePath: imageFromGallery!.path,
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
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
                    onPressed: () {
                      // TODO:
                      // 1. Validate form
                      // 2. Update to backend
                      // 3. Show update successfully dialog
                      if (true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateSuccessfullyPage(),),
                        );
                      }
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

class AskForJoinPage extends StatefulWidget {
  const AskForJoinPage({ Key? key }) : super(key: key);

  @override
  State<AskForJoinPage> createState() => _AskForJoinPageState();
}

class _AskForJoinPageState extends State<AskForJoinPage> {
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
                Image.asset("assets/images/avatar.png", width: 164.w, height: 164.w,),
                SizedBox(height: 30.h,),
                // TODO: fetched group name from backend
                Text("我們這一家", style: largeTextStyle,),

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
  const CreateSuccessfullyPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: lightYellow,),
          Column(
            children: [
              SizedBox(
                width: 348.w,
                height: 221.h,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r),),
                  color: yellow,
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("恭喜創辦成功！使用邀請碼", style: smallTextStyle,),
                      Text("來邀請其他人吧！", style: smallTextStyle,),
                      SizedBox(height: 20.h,),
                      RoundedElevatedButton(
                        onPressed: () {
                          // TODO: generate a groupID
                          Copy2Clipboard(context, "0ab4523b");
                        },
                        fixedSize: Size(206.w, 40.h,),
                        elevated: false,
                        backgroundColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "邀請碼: 0ab4523b",
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