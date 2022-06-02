import 'dart:io';
import 'package:famistory/services/service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    required this.avatar,
    required this.size,
  }) : super(key: key);

  final String avatar;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        child: ClipOval(
          child: Image.asset(
            avatar,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class Comments extends StatefulWidget {
  const Comments({
    required this.avatar,
    required this.comment,
    Key? key
  }) : super(key: key);

  final String avatar;
  final String comment;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Row(
              children: [
                UserAvatar(avatar: widget.avatar, size: 45.w,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text("user2", style: TextStyle(fontSize: 17.sp,),),
                ),
              ],
            ),
            Center(child: Text(widget.comment, style: TextStyle(fontSize: 17.sp,),)),
            SizedBox(height: 10.h,),
          ],
        ),
      ),
    );
  }
}

class OnePost extends StatefulWidget {
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
  State<OnePost> createState() => _OnePostState();
}

class _OnePostState extends State<OnePost> {
  bool _hasLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0x32FFD66B)),
      child: Column(
        children: [
          SizedBox(height: 10.h,),
          // user avatar and user name
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20.w),
              UserAvatar(avatar: widget.avatar, size: 45.w,),
              SizedBox(width: 10.w),
              Text(widget.name, style: TextStyle(fontSize: 18.sp),),
            ],
          ),
          SizedBox(height: 10.h,),
          // image post and context
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFD66B),
                borderRadius: BorderRadius.all(Radius.circular(20.r))
              ),
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    // Image.file(File(photo.path),),
                    Image.asset(widget.photo),
                    SizedBox(height: 10.h,),
                    widget.content,
                    
                    // liked
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("14 x "),
                        InkWell(
                          child: _hasLiked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                          onTap: () => setState(() {
                            _hasLiked = !_hasLiked;
                          }) 
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Comments(avatar: widget.avatar, comment: "台北這邊就已經很冷了...",),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,),
            child: SizedBox(
              width: 291.w,
              height: 41.h,
              child: Center(
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 30.w),
                    hintText: "有什麼話想說的嗎？",
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
            ),
          ),
        ],
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
  final TextEditingController _controller = TextEditingController();
  final List<String> exampleContent = <String>["今天", "天氣", "真好"];
  final _soundRecorder = SoundRecorder();
  XFile? image;

  final _visibility = [
    "全部人可見",
    "我們這一家",
    "他們這一家",
    "你們這一家"
  ];
  String _dropDownValue = "全部人可見";

  bool _isOn = false;

  @override
  void initState() {
    _soundRecorder.init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _soundRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0x32FFD66B),
          child: Stack(
            children:[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h,),
                    // image pre-view
                    Container(
                      child: image != null ? Image.file(File(image!.path)) : null,
                    ),
                    SizedBox(height: 20.h,),
                    TextField(
                      controller: _controller,
                      maxLines: null,
                      minLines: 6,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 30.w,),
                        hintText: "試著在文章的最後面，問問其他家人們對這事情有什麼想法吧！",
                        hintStyle: const TextStyle(color: Colors.black26,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide.none,
                        ),
                        // fillColor: Colors.white,
                        // filled: true,
                      ),
                    ),
                    SizedBox(height: 150.h,),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  child: Icon(Icons.photo, size: 84.w,),
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
              ),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 191.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFFFD66B),
                          width: 4.w,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.r)),
                        shape: BoxShape.rectangle
                      ),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: _dropDownValue,
                            icon: const Icon(Icons.keyboard_arrow_down),    
                            items: _visibility.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items, style: const TextStyle(color: Colors.black),),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _dropDownValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(97.w, 54.h),
                        primary: const Color(0xFFFFD66B),
                      ),
                      child: Text("發送", style: TextStyle(fontSize: 28.sp, color: Colors.black),),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150.w,
        height: 150.w,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              Directory tempDir = await path_provider.getTemporaryDirectory();
              String path = '${tempDir.path}/content.wav';
              await _soundRecorder.toggleRecording(path);
              if (!_soundRecorder.isRecording) {
                  await Speech2Text().connect(path, (text) => _controller.text += ('$text\n'), "MTK_ch");
              }      
              setState(() {
                _soundRecorder.isRecording;
                _isOn = !_isOn;
              });
            },
            elevation: 5,
            backgroundColor: Colors.white,
            foregroundColor: _isOn ? Colors.red:Colors.black,
            child: Icon(Icons.mic, size: 40.w),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
