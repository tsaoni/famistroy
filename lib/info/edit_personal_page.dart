import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/info/password_page.dart';
import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/widgets/widgets.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({ Key? key }) : super(key: key);

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {

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
                      width: 171.w,
                      height: 171.w,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 10.w, color: Colors.white,),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: UserAvatar(avatar: "assets/images/avatar.png", size: 130.w,),
                          ),
                          Align(
                            alignment: const Alignment(0.7, 0.7),
                            child: SizedBox(
                              width: 44.w,
                              height: 44.w,
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: add change avatar page
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
                    
                    RoundedElevatedButtonWithBorder(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage())
                        );
                      },
                      backgroundColor: Colors.white,
                      borderColor: yellow,
                      fixedSize: Size(129.w, 52.h),
                      child: Text("變更密碼", style: smallTextStyle,),
                    ),
                
                    const OneTextInputField(value: "王小明", title: "姓名",),
                    SizedBox(height: 20.h,),
                    const OneTextInputField(value: "1953/08/19", title: "生日",),
                    SizedBox(height: 20.h,),
                    const OneTextInputField(value: "男", title: "性別",),
          
                    SizedBox(height: 20.h,),
          
                    RoundedRectElevatedButton(
                      backgroundColor: yellow,
                      radius: 10.r,
                      onPressed: () {
                        // TODO: Update the data
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