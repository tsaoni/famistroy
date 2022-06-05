import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:famistory/info/password_page.dart';
import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/widgets/widgets.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({ Key? key }) : super(key: key);

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {

  String? _image = "assets/images/avatar.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: lightYellow,
            ),
            SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 50.h,),
                    // Stack edit icon on the UserAvatar
                    SizedBox(
                      width: 171.w,
                      height: 171.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 10.w, color: Colors.white,),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: UserAvatar(avatar: _image!, size: 130.w,),
                          ),
                          Align(
                            alignment: const Alignment(0.7, 0.7),
                            child: SizedBox(
                              width: 44.w,
                              height: 44.w,
                              child: ElevatedButton(
                                onPressed: () async {
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
                                style: ElevatedButton.styleFrom(
                                  primary: yellow,
                                  shape: const CircleBorder(),
                                  padding: EdgeInsets.all(8.w)
                                ),
                                child: Icon(Icons.edit_rounded, color: lightBlack, size: 30.w,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 10.h,),
                    RoundedElevatedButtonWithBorder(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChangePasswordPage())
                        );
                      },
                      backgroundColor: Colors.white,
                      borderColor: yellow,
                      fixedSize: Size(129.w, 52.h),
                      child: Text("變更密碼", style: smallTextStyle,),
                    ),
                
                    SizedBox(height: 20.h,),
                    const OneTextInputField(value: "王小明", title: "姓名",),
                    SizedBox(height: 20.h,),
                    const OneTextInputField(value: "1953/08/19", title: "生日",),
                    SizedBox(height: 20.h,),
                    const OneTextInputField(value: "男", title: "性別",),
          
                    SizedBox(height: 50.h,),
          
                    RoundedRectElevatedButton(
                      backgroundColor: yellow,
                      radius: 10.r,
                      onPressed: () {
                        // TODO: Update the data
                        // name, birth, gender, avatar
                      },
                      fixedSize: Size(178.w, 54.h),
                      child: Text("儲存變更", style: largeTextStyle,),
                    ),
          
                    SizedBox(height: 20.h,),
          
                    const CancelTextButton(text: "取消變更",),
                  ],
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}