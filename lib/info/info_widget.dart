import 'dart:convert';

import 'package:famistory/info/person_info.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:famistory/info/info_page.dart';
import 'package:famistory/services/service.dart';
import 'package:famistory/widgets/widgets.dart';

class Family {
  const Family._({
    required this.fid,
    required this.fname,
    required this.photo,
    required this.type
  });

  final List<String> fid;
  final List<String> fname;
  final List<String> photo;
  final List<String> type;

  factory Family.fromJson(Map<String, dynamic> jsons) {
    List<String> fid = [];
    List<String> fname = [];
    List<String> photo = [];
    List<String> type = [];
  
    for (final family in jsons["groups"]) {
      fid.add(family["fid"]);
      fname.add(family["fname"]);
      photo.add(
        family["image"]["image"]
      );
      type.add(family["image"]["type"]);
    }
    return Family._(
      fid: fid,
      fname: fname,
      photo: photo,
      type: type
    );
  }
}

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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupInfoPage(
                fid: widget.code,
                photo: widget.image,
                fname: widget.groupName,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 40.w,),
            Image.memory(
              base64Decode(widget.image),
              width: 109.w,
              height: 109.w,
            ),
            SizedBox(width: 20.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10.w,),
                    Text(
                      widget.groupName,
                      style: TextStyle(
                        fontSize: 28.sp,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(width: 10.w,),
                    InkWell(
                      child: Icon(Icons.volume_up),
                      onTap: () async {
                        await Text2Speech().connect(widget.soundPlayer.play, widget.groupName, "female");
                      },
                    ),
                  ],
                ),
                RoundedElevatedButton(
                  fixedSize: Size(201.w, 40.h,),
                  onPressed: () {
                    copy2Clipboard(context, widget.code);
                  },
                  backgroundColor: yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "邀請碼: ${widget.code}",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: const Color(0x90000000),
                        ),
                      ),
                      ImageIcon(const AssetImage("assets/images/Icon-Artwork.png")),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoPageNavigationBar extends StatelessWidget {
  const InfoPageNavigationBar({
    Key? key,
    required this.child,
    required this.onTapSettingIcon,
    required this.height,
  }) : super(key: key);

  final Widget child;
  final double height;
  final Function() onTapSettingIcon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
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
          child: child
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 50.h, right: 30.w),
            child: InkWell(
              onTap: onTapSettingIcon,
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

class InfoPageBody extends StatefulWidget {
  const InfoPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<InfoPageBody> createState() => _InfoPageBodyState();
}

class _InfoPageBodyState extends State<InfoPageBody> {

  final _soundPlayer = SoundPlayer();
  
  @override
  void initState() {
    super.initState();
    _soundPlayer.init();
    _family = _fetechFamilyInfo();
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

  late Future<Family> _family; 

  Future<Family> _fetechFamilyInfo() async {
    final url = Uri.parse("http://140.116.245.146:8000/group/uid/${PersonInfo.uid}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Family.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    else {
      throw Exception('Failed to fetch data from server');
    }
  }


  @override
  Widget build(BuildContext context) {
    _family = _fetechFamilyInfo();
    return Padding(
      padding: EdgeInsets.only(top: 290.h, bottom: 110.h,),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _family = _fetechFamilyInfo();
          });
        },
        child: FutureBuilder<Family>(
          future: _family,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.fid.length,
                itemBuilder: (context, index) {
                  return GroupComponent(
                    image: snapshot.data!.photo[index],
                    groupName: snapshot.data!.fname[index],
                    code: snapshot.data!.fid[index],
                    soundPlayer: _soundPlayer,
                  );
                }
              );
            }
            else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error!}"));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
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
                const Icon(Icons.add, color: lightBlack,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MemberComponent extends StatelessWidget {
  const MemberComponent({
    Key? key,
    required this.avatar,
    required this.uname
  }) : super(key: key);

  final String avatar;
  final String uname;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          SizedBox(height: 25.h,),
          Row(
            children: [
              SizedBox(
                width: 38.w,
                height: 38.w,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.memory(
                      base64Decode(avatar),
                      width: 38.w,
                      height: 38.w,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w,),
              Text(uname, style: smallTextStyle,),
            ],
          ),    
        ],
      ),
    );
  }
}