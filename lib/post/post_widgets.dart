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

class NewPostBtn extends StatelessWidget {
  const NewPostBtn({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 80.w,
      child: FittedBox(
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPostPage(),
              )
            );
          }
        ),
      ),
  );
  }
}

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("新增貼文頁面", style: TextStyle(fontSize: 28.sp),),
          TextFormField(
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: "請輸入文字...",
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(178.w, 54.h),
              primary: Colors.black,
            ),
            child: Text("送出", style: TextStyle(fontSize: 28.sp,),),
            onPressed: () {
              // TODO: Add post to db
            },
          ),
          // TODO: Add onPressed functino to return previous page
          RichText(text: TextSpan(
            text: "取消變更", 
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey,
              decoration: TextDecoration.underline,
              ),
            ),
          ),
          Row(
            // TODO: Add onPressed function to each icon
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.photo, size: 84.w,),
              Icon(Icons.mic, size: 180.w,),
              Icon(Icons.keyboard, size: 84.w,),
            ],
          ),
        ],
      )
    ),
  );
  }
}