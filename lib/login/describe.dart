import 'package:famistory/login/register.dart';
import 'package:famistory/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgets.dart';

class DescribePage extends StatelessWidget {
  const DescribePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: 3.w,
                  height: 100.h,
                ),
                SizedBox(
                  width: 320.w,
                  height: 50.h,
                  child: Text("註冊說明", style: TextStyle(
                      fontSize: 28.sp, fontWeight: FontWeight.bold),)
                ),
                SizedBox(width: 3.w, height: 40.h),
                SizedBox(
                  width: 320.w,
                  height: 20.h,
                  child: Text("註冊一個帳號，建立與家人們的聯繫吧!", style: TextStyle(
                      fontSize: 14.sp, fontWeight: FontWeight.bold),)
                ),
                SizedBox(width: 3.w, height: 30.h),
                SizedBox(
                    width: 320.w,
                    height: 20.h,
                    child: Text("第一步：跟著指示註冊一個帳號。", style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold))
                ),
                SizedBox(width: 3.w, height: 30.h),
                SizedBox(
                    width: 320.w,
                    height: 50.h,
                    child: Text("第二步：建立一個「家族」並複製邀請碼傳送給你的家人們或是輸入從家人們那邊獲得的「家族邀請碼」進入家族！", style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold))
                ),
                SizedBox(width: 3.w, height: 30.h),
                SizedBox(
                    width: 320.w,
                    height: 50.h,
                    child: Text("第三步：依照指示選擇你在家族中為第幾代的（會請你依據傳送邀請碼的人與你之間的關係來判斷）", style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold))
                ),
                SizedBox(width: 3.w, height: 30.h),
                SizedBox(
                    width: 320.w,
                    height: 20.h,
                    child: Text("第四步：可以為你的家族設立主題概念！", style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold))
                ),
                SizedBox(width: 3.w, height: 30.h),
                SizedBox(
                    width: 320.w,
                    height: 20.h,
                    child: Text("第五步：開始分享你的日常吧！", style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.bold))
                ),
                SizedBox(width: 3.w, height: 40.h),
                RoundedRectElevatedButton(
                  backgroundColor: const Color(0xffffd66b),
                  fixedSize: Size(150.w, 50.h),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterForm())
                    );
                  },
                  child: Text("我了解了!", style: smallTextStyle),
                ),
              ],
            )
        )
    );
  }

}