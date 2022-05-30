import 'package:famistory/info/create_page.dart';
import 'package:famistory/info/edit_personal_page.dart';
import 'package:famistory/info/info_widget.dart';
import 'package:famistory/info/setting_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/post/post_widgets.dart';

final smallTextStyle = TextStyle(
  fontSize: 17.sp,
  color: const Color(0x90000000),
);

final largeTextStyle = TextStyle(
  fontSize: 28.sp,
  color: const Color(0xFF000000),
);

const lightBlack = Color(0x90000000);
const lightYellow = Color.fromARGB(51, 255, 220, 107);
const yellow = Color.fromARGB(255, 255, 213, 107);

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  // TODO: display info depends on groups that user joined in 
  // select * from jointable where uid = user
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Stack widget use bottom up method
        child: Stack(
          children: [// background
            Container(
              color: lightYellow,
            ),
            const InfoPageNavigationBar(),
            const InfoPageBody(),
            const FloatingElevatedButton(),
          ],
        ),
      ),
    );
  }
}

class InfoPageBody extends StatelessWidget {
  const InfoPageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 290.h, bottom: 110.h,),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return const GroupComponent(
            image: "assets/images/photo.png",
            groupName: "我們這一家",
            code: "0ab4523"
          );
        },
        itemCount: 5,
      ),
    );
  }
}

class FloatingElevatedButton extends StatelessWidget {
  const FloatingElevatedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: SizedBox(
          width: 191.w,
          height: 65.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => const CreatePage()
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: StadiumBorder(),
              side: BorderSide(width: 5.w, color: yellow),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("新增/加入家族", style: smallTextStyle,),
                Icon(Icons.add, color: lightBlack,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoPageNavigationBar extends StatelessWidget {
  const InfoPageNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 280.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFFFFDB5A),
                Color(0XFFFFBA7A),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40.r),
              bottomLeft: Radius.circular(40.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 10.w, color: Colors.white,),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: UserAvatar(avatar: "assets/images/avatar.png", size: 130.w,),
              ),
              SizedBox(width: 30.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("王小明", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: 139.w,
                    height: 40.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => const EditPersonalInfoPage()
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Colors.white,
                        elevation: 5,
                      ),
                      child: Text(
                        "編輯個人資料",
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 50.h, right: 30.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const GroupSettingPage()
                  ),
                );
              },
              child: ImageIcon(
                const AssetImage("assets/images/Settings.png"),
                size: 33.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}