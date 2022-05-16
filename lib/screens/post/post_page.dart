import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.avatar,
  }) : super(key: key);

  final String avatar;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: ClipOval(
        child: Image.asset(
          avatar,
          fit: BoxFit.cover,
          width: 80.w,
          height: 80.h,
        ),
      ),
    );
  }
}

class OnePost extends StatelessWidget {
  const OnePost({
    required this.name,
    required this.avatar,
    required this.content,
    required this.photo,
    Key? key
  }): super(key: key);

  final String name;
  final String avatar;
  final String content;
  final String photo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // user avatar and user name
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20.w),
            UserAvatar(avatar: avatar),
            SizedBox(width: 10.w),
            Text(
              name,
              style: TextStyle(fontSize: 18.sp),
            ),
          ],
        ),
        // image post and context
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Image.asset(photo),
              SizedBox(height: 10.h,),
              Text(content),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            UserAvatar(avatar: avatar),
            SizedBox(
              width: 292.w,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "請輸入你的留言",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

final String name = "user";
final String avatar = "assets/images/avatar.png";
final String content = "doge 🐶";
final String photo = "assets/images/photo.png";

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(8.w),
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return Divider(height: 50.h, thickness: 1.h,);
            }
            else {
              return OnePost(name: name, avatar: avatar, content: content, photo: photo);
            }
          },
        ),
      ),
    );
  }
}