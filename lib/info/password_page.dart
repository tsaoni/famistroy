import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _checkPasswordController = TextEditingController();

  bool _isValid = true;
  bool _areSame = true;

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
                  Text("變更密碼", style: largeTextStyle,),
                  SizedBox(height: 50.h,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isValid ? "請輸入舊密碼" : "請輸入舊密碼(密碼錯誤)",
                        style: _isValid
                          ? TextStyle(fontSize: 17.sp, color: lightBlack)
                          : TextStyle(fontSize: 17.sp, color: Colors.red),
                      ),
                      SizedBox(height: 5.h,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: grey,
                            width: 3.w,
                          ),
                          borderRadius: BorderRadius.circular(20.r)
                        ),
                        width: 260.w,
                        height: 32.h,
                        child: TextField(
                          controller: _oldPasswordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 13.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 50.h,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("請輸入新密碼", style: smallTextStyle),
                      SizedBox(height: 5.h,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: grey,
                            width: 3.w,
                          ),
                          borderRadius: BorderRadius.circular(20.r)
                        ),
                        width: 260.w,
                        height: 32.h,
                        child: TextField(
                          controller: _newPasswordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 13.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20.h,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _areSame ? "請輸入新密碼" : "請輸入新密碼(新密碼不一致)",
                        style: _areSame
                          ? TextStyle(fontSize: 17.sp, color: lightBlack)
                          : TextStyle(fontSize: 17.sp, color: Colors.red),
                      ),
                      SizedBox(height: 5.h,),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: grey,
                            width: 3.w,
                          ),
                          borderRadius: BorderRadius.circular(20.r)
                        ),
                        width: 260.w,
                        height: 32.h,
                        child: TextField(
                          controller: _checkPasswordController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 13.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50.h,),

                  RoundedRectElevatedButton(
                    backgroundColor: yellow,
                    radius: 10.r,
                    onPressed: () {
                      // TODO:
                      // fetch pwd from backend
                      if (sha256.convert(utf8.encode(_oldPasswordController.text)) == sha256.convert(utf8.encode("Andy"))) {
                        setState(() {
                          _isValid = true;
                        });
                      }
                      else {
                        setState(() {
                          _isValid = false;
                        });
                      }
                      if (_newPasswordController.text != _checkPasswordController.text) {
                        setState(() {
                          _areSame = false;
                        });
                      }
                      else {
                        setState(() {
                          _areSame = true;
                        });
                      }
                      if (_isValid && _areSame) {
                        // update to db
                      }
                      // Navigator.pop(context);
                    },
                    fixedSize: Size(178.w, 54.h),
                    child: Text("儲存變更", style: largeTextStyle,),
                  ),
                  SizedBox(height: 20.h,),

                  const CancelTextButton(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}