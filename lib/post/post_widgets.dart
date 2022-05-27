import 'dart:io';
import 'package:famistory/post/service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';


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
  final RichText content;
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
            Text(name, style: TextStyle(fontSize: 18.sp),),
          ],
        ),
        // image post and context
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Image.file(File(photo.path),),
              Image.asset(photo),
              SizedBox(height: 10.h,),
              content,
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

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> exampleContent = <String>["今天", "天氣", "真好"];
  final _soundPlayer = SoundPlayer();

  XFile? image;

  @override
  void initState() {
    _soundPlayer.init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "新增貼文頁面",
                style: TextStyle(fontSize: 28.sp),
              ),
              // image pre-view
              Container(
                child: image != null ? Image.file(File(image!.path)) : null,
              ),
              TextFormField(
                minLines: 6,
                maxLines: null,
                controller: _controller,
                keyboardType: TextInputType.text,
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
                  if (image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("請選擇相片"),
                        action: SnackBarAction(label: "OK", onPressed: () => {}),
                      ),
                    );
                  } 
                  else if (_controller.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("請輸入內文"),
                        action: SnackBarAction(label: "OK", onPressed: () => {}),
                      ),
                    );
                  }
                  else {
                    Navigator.pop(context);
                  }
                },
              ),
              GestureDetector(
                child: Text(
                  "取消變更",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
              Row(
                // TODO: Add onPressed function to each icon
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // photo icon
                  InkWell(
                    child: Icon(Icons.photo,size: 84.w,),
                    onTap: () async {
                      // TODO: Add backend to store uploaded image

                      final ImagePicker picker = ImagePicker();
                      final imageFromGallery =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        image = imageFromGallery;
                      });
                    },
                  ),
                  Icon(Icons.mic,size: 180.w,),
                  Icon(Icons.keyboard,size: 84.w,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
