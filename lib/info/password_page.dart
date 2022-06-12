import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:famistory/widgets/widgets.dart';
import 'package:famistory/info/person_info.dart';

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
                    onPressed: () async {
                      var url = Uri.parse('http://140.116.245.146:8000/password');
                      var response = await http.post(url,
                        headers: {"Content-type": "application/json"}, 
                        body: jsonEncode({"uid": PersonInfo.uname})
                      );
                      if (response.statusCode == 200) {
                        final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
                        if (sha256.convert(utf8.encode(_oldPasswordController.text)).toString() == decodedResponse["password"]) {
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
                          // update to backend
                          final url = Uri.parse('http://140.116.245.146:8000/password');
                          final response = await http.put(url,
                            headers: {"Content-type": "application/json"},
                            body: jsonEncode({
                              "uid": PersonInfo.uid,
                              "password": sha256.convert(utf8.encode(_newPasswordController.text)).toString(),
                            }),
                          );
                          Future.delayed(const Duration(milliseconds: 1), () {
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text("更新成功", textAlign: TextAlign.center,),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              Navigator.pop(context);
                            
                            }
                            else {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text("更新失敗", textAlign: TextAlign.center,),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              throw Exception('Failed to update the password!');
                            }
                          });
                        }
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
          ],
        ),
      ),
    );
  }
}