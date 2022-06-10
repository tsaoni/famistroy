import 'package:famistory/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';
import 'describe.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  final String photo = "assets/images/famistory.png";

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor: const Color.fromARGB(51, 255, 220, 107),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(width: 3.w, height: 123.h,),
              SizedBox(
                width: 185.w,
                height: 173.h,
                child: Image.asset(photo),
              ),
              SizedBox(width: 3.w, height: 65.h,),
              Text("登入帳號", style: TextStyle(
                fontSize: 28.sp, fontWeight: FontWeight.bold),),
              SizedBox(width: 3.w, height: 30.h,),
              const LoginInputField(
                title: '帳號',
                ),
              SizedBox(width: 3.w, height: 20.h,),
              const LoginInputField(title: '密碼',),
              SizedBox(width: 3.w, height: 68.h,),
              RoundedRectElevatedButton(
                backgroundColor: const Color(0xffffd66b),
                fixedSize: Size(150.w, 50.h),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage())
                  );
                },
                child: Text("登入", style: smallTextStyle),

              ),
              SizedBox(
                width: 3.w,
                height: 30.h,
              ),
              InkWell(
                  child: const Text('還沒建立帳號嗎? 註冊'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DescribePage())
                    );
                  }
              )
            ],
          )
      )
      );
  }

}