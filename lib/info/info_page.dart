import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/info/create_page.dart';
import 'package:famistory/info/info_widget.dart';
import 'package:famistory/services/service.dart';
import 'package:famistory/widgets/widgets.dart';

import 'package:famistory/info/edit_page.dart';
import 'package:famistory/info/setting_page.dart';
import 'package:famistory/post/post_widgets.dart';


class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _soundPlayer = SoundPlayer();
  
  @override
  void initState() {
    _soundPlayer.init();
    super.initState();
  }

  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  Future play(String pathToAudio) async {
    await _soundPlayer.play(pathToAudio);
    setState(() {
      _soundPlayer.init();
      _soundPlayer.isPlaying;
    });
  }

  // TODO: display info depends on groups that user joined in 
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
            InfoPageNavigationBar(
              height: 280.h,
              onTapSettingIcon: () => 
                Navigator.push(
                  context, MaterialPageRoute(
                      builder: (context) => PersonalSettingPage(),
                  ),
                ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserAvatarWithBorder(avatar: "assets/images/avatar.png", size: 130.w,),
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
            InfoPageBody(soundPlayer: _soundPlayer,),
            FloatingElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => CreatePage()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({Key? key}) : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: lightYellow,),
            InfoPageNavigationBar(
              // TODO: fetch group info from backend
              height: 400.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 60.h,),
                      UserAvatarWithBorder(avatar: "assets/images/avatar.png", size: 164.w),
                      SizedBox(height: 15.h,),
                      Row(
                        children: [
                          Text("我們這一家", style: largeTextStyle,),
                          SizedBox(width: 10.w,),
                          const Icon(Icons.edit, color: lightBlack,),
                        ],
                      ),
                      SizedBox(height: 25.h,),
                      RoundedElevatedButton(
                        fixedSize: Size(129.w, 41.h,),
                        onPressed: () {
                          // TODO: Change theme
                        },
                        backgroundColor: Colors.white,
                        child: Text("變更主題", style: smallTextStyle,)
                      ),
                    ],
                  ), 
                ],
              ),
              onTapSettingIcon: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GroupSettingPage())),
            ),
            Padding(
              padding: EdgeInsets.only(top: 420.h, left: 30.w,),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("成員", style: smallTextStyle,),
                    SizedBox(height: 25.h,),
                    Row(
                      children: [
                        UserAvatar(avatar: "assets/images/avatar.png", size: 38.w),
                        SizedBox(width: 20.w,),
                        Text("第一代 王小明", style: smallTextStyle,),
                      ],
                    ),
                    SizedBox(height: 25.h,),
                    Row(
                      children: [
                        UserAvatar(avatar: "assets/images/avatar.png", size: 38.w),
                        SizedBox(width: 20.w,),
                        Text("第一代 王小明", style: smallTextStyle,),
                      ],
                    ),
                    SizedBox(height: 25.h,),
                    Row(
                      children: [
                        UserAvatar(avatar: "assets/images/avatar.png", size: 38.w),
                        SizedBox(width: 20.w,),
                        Text("第一代 王小明", style: smallTextStyle,),
                      ],
                    ),
                    SizedBox(height: 25.h,),
                    Row(
                      children: [
                        UserAvatar(avatar: "assets/images/avatar.png", size: 38.w),
                        SizedBox(width: 20.w,),
                        Text("第一代 王小明", style: smallTextStyle,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}