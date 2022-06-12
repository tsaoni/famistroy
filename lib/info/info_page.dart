import 'package:famistory/info/person_info.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import 'package:famistory/info/create_page.dart';
import 'package:famistory/info/info_widget.dart';
import 'package:famistory/info/edit_page.dart';
import 'package:famistory/info/setting_page.dart';
import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/widgets/widgets.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
                      builder: (context) => const PersonalSettingPage(),
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
                      Text(currentUser.uname, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),),
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
            const InfoPageBody(),
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

class Member {
  const Member._({
    required this.uname,
    required this.avatar,
  });

  final List<String> uname;
  final List<String> avatar;

  factory Member.fromJson(Map<String, dynamic> jsons) {
    List<String> uname = [];
    List<String> avatar = [];

    for (final member in jsons["members"]) {
      uname.add(member["uname"]);
      avatar.add(member["avatar"]["image"]);
    }

    return Member._(uname: uname, avatar: avatar);
  }

}

class GroupInfoPage extends StatefulWidget {
  const GroupInfoPage({
    Key? key,
    required this.fname,
    required this.photo,
    required this.fid
  }) : super(key: key);

  final String fname;
  final String photo;
  final String fid;

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  
  late Future<Member> _member;

  Future<Member> _fetchMembersInfo() async {
    final url = Uri.parse("http://140.116.245.146:8000/group/${widget.fid}/list");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final res = jsonDecode(utf8.decode(response.bodyBytes));
      return Member.fromJson(res);
    }
    else {
      throw Exception('Failed to fetch data from server');
    }
  }
  
  @override
  void initState() {
    super.initState();
    _member = _fetchMembersInfo();
  }

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
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 10.w, color: Colors.white,),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: SizedBox(
                          width: 164.w,
                          height: 164.w,
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.memory(
                                base64Decode(widget.photo),
                                width: 164.w,
                                height: 164.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // UserAvatarWithBorder(avatar: "assets/images/avatar.png", size: 164.w),
                      SizedBox(height: 15.h,),
                      Row(
                        children: [
                          Text(widget.fname, style: largeTextStyle,),
                          SizedBox(width: 10.w,),
                          const Icon(Icons.edit, color: lightBlack,),
                        ],
                      ),
                      SizedBox(height: 15.h,),
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
                    // TODO: fetch members from backend
                    FutureBuilder<Member> (
                      future: _member,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                            width: 200.w,
                            height: 300.h,
                            child: ListView.builder(
                              itemCount: snapshot.data!.avatar.length,
                              itemBuilder: (context, index) {
                                return MemberComponent(
                                  avatar: snapshot.data!.avatar[index],
                                  uname: snapshot.data!.uname[index],
                                );
                              } 
                            ),
                          );
                        }
                        else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error!}"),);
                        }
                        return const Center(child: CircularProgressIndicator(),);
                      }
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