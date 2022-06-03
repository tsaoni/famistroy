import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/info/edit_personal_page.dart';
import 'package:famistory/info/setting_page.dart';
import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/services/service.dart';
import 'package:famistory/widgets/widgets.dart';

class GroupComponent extends StatefulWidget {
  const GroupComponent({
    Key? key,
    required this.image,
    required this.groupName,
    required this.code,
    required this.soundPlayer,
  }) : super(key: key);

  final String image;
  final String groupName;
  final String code;
  final SoundPlayer soundPlayer;

  @override
  State<GroupComponent> createState() => _GroupComponentState();
}

class _GroupComponentState extends State<GroupComponent> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.image,
            width: 100.w,
            height: 100.h,
          ),
          SizedBox(width: 20.w,),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.groupName,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  InkWell(
                    child: Icon(Icons.volume_up),
                    onTap: () async {
                      await Text2Speech().connect(widget.soundPlayer.play, widget.groupName, "female");
                    },
                  ),
                ],
              ),
              RoundedElevatedButton(
                onPressed: () {
                  Copy2Clipboard(context, widget.code);
                },
                backgroundColor: yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "邀請碼: ${widget.code}",
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: const Color(0x90000000),
                      ),
                    ),
                    ImageIcon(AssetImage("assets/images/Icon-Artwork.png")),
                  ],
                ),
              ),
            ],
          ),
        ],
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
class InfoPageBody extends StatelessWidget {
  const InfoPageBody({
    required this.soundPlayer,
    Key? key,
  }) : super(key: key);

  final SoundPlayer soundPlayer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 290.h, bottom: 110.h,),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return GroupComponent(
            image: "assets/images/photo.png",
            groupName: "我們這一家",
            code: "0ab4523",
            soundPlayer: soundPlayer,
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
    required this.onPressed,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: SizedBox(
          width: 191.w,
          height: 65.h,
          child: RoundedElevatedButtonWithBorder(
            onPressed: onPressed,
            backgroundColor: Colors.white,
            borderColor: yellow,
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