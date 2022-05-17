import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/post/screens/post_widgets.dart';


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
          itemCount: 5,
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
      floatingActionButton: NewPostBtn(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}