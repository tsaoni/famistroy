import 'dart:convert';

import 'package:famistory/info/person_info.dart';
import 'package:famistory/info/setting_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:famistory/info/password_page.dart';
import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/widgets/widgets.dart';
import 'package:mysql_client/mysql_client.dart';
import 'person_info.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({ Key? key }) : super(key: key);

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {

  List<TextEditingController>controllers = [TextEditingController(), TextEditingController(), TextEditingController()];
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
                    // Stack edit icon on the UserAvatar
                    SizedBox(
                      width: 141.w,
                      height: 141.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 10.w, color: Colors.white,),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            // child: SizedBox(
                            //   width: 130.w,
                            //   height: 130.w,
                            //   child: CircleAvatar(
                            //     child: ClipOval(
                            //       child: Image.memory(
                            //         base64Decode(PersonInfo.avatar),
                            //         fit: BoxFit.contain,
                            //       ),
                            //     ),
                            //   ),
                            // ),
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

                    SizedBox(height: 10.h,),
                    OneTextInputField(value: "", title: "姓名", controller: controllers[0],),
                    SizedBox(height: 10.h,),
                    OneTextInputField(value: "", title: "生日", controller: controllers[1],),
                    SizedBox(height: 10.h,),
                    OneTextInputField(value: "", title: "性別", controller: controllers[2],),
          
                    SizedBox(height: 25.h,),
          
                    RoundedRectElevatedButton(
                      backgroundColor: yellow,
                      radius: 10.r,
                      onPressed: () async {
                        // TODO: Update the data
                        // name, birth, gender, avatar
                        final conn = await MySQLConnection.createConnection(
                          host: "140.116.245.146",
                          port: 3308,
                          userName: "famistory",
                          password: "ofwgjyyi",
                          databaseName: "famistory", // optional
                        );
                        await conn.connect();
                        await conn.execute("UPDATE users SET uname = :uname, birth = :birth, gender = :gender WHERE uid = :uid",
                            {"uname": controllers[0].text.toString(), "birth": controllers[1].text.toString(), "gender": controllers[2].text.toString(), "uid": PersonInfo.uid});

                        var result = await conn.execute("SELECT * from users WHERE uid = :uid", {"uid": PersonInfo.uid});
                        for(final row in result.rows){
                          print(row.assoc());
                        }
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