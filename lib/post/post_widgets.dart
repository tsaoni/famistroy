import 'dart:convert';
import 'dart:io' as io;
import 'package:famistory/info/person_info.dart';
import 'package:famistory/services/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
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
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class UserAvatarWithBorder extends StatelessWidget {
  const UserAvatarWithBorder({
    Key? key,
    required this.avatar,
    required this.size,
  }) : super(key: key);

  final String avatar;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 10.w, color: Colors.white,),
        borderRadius: BorderRadius.circular(100),
      ),
      child: UserAvatar(avatar: avatar, size: size),
    );
  }
}

class Comment {
  const Comment._({
    required this.cid,
    required this.avatar,
    required this.uname,
    required this.comment,
  });

  final List<String> cid;
  final List<String> avatar;
  final List<String> uname;
  final List<String> comment;

  factory Comment.fromJson(Map<String, dynamic> jsons) {
    List<String> cid = [];
    List<String> avatar = [];
    List<String> uname = [];
    List<String> c = [];

    for (final comment in jsons["comments"]) {
      cid.add(comment["cid"]);
      avatar.add(comment["avatar"]["image"]);
      uname.add(comment["uname"]);
      c.add(comment["comment"]);
    }

    return Comment._(cid: cid, avatar: avatar, uname: uname, comment: c);
  }
}

class Comments extends StatefulWidget {
  const Comments({
    Key? key,
    required this.aid
  }) : super(key: key);

  final String aid;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  final TextEditingController _controller = TextEditingController();
  late Future<Comment> _comment;
  bool _hasComments = false;
  bool _needExpand = false;


  Future<Comment> _fetchCommentInfo() async {
    final url = Uri.parse("http://140.116.245.146:8000/${widget.aid}/comments");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // print(jsonDecode(utf8.decode(response.bodyBytes)));
      return Comment.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    else {
      throw Exception('Failed to fetch data from server');
    }
  }

  @override
  void initState() {
    super.initState();
    _comment = _fetchCommentInfo();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _comment = _fetchCommentInfo();
    return Column(
        children: [
          FutureBuilder<Comment>(
            future: _comment,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.cid.isNotEmpty) {
                  _hasComments = true;
                  if (snapshot.data!.cid.length > 1) {
                    _needExpand = true;
                  }
                }
                // TRICK: ListView need a height constraint from a parent widget
                return SizedBox(
                  height: _hasComments ? (_needExpand ? 200.h : 100.h) : 1.h,
                  child: ListView.builder(
                    itemCount: snapshot.data!.cid.length,
                    itemBuilder: (context, index) {
                      return OneComment(
                        uname: snapshot.data!.uname[index],
                        avatar: snapshot.data!.avatar[index],
                        comment: snapshot.data!.comment[index]
                      );
                    }
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"),);
              }
              return const CircularProgressIndicator();
            }
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h,),
            child: SizedBox(
              width: 291.w,
              height: 41.h,
              child: Center(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (text) async {
                    final url = Uri.parse("http://140.116.245.146:8000/comments");
                    final response = await http.post(url, 
                      headers: {"Content-type": "application/json"}, 
                      body: jsonEncode({
                        "uid": PersonInfo.uid,
                        "aid": widget.aid,
                        "comment": text,
                      })
                    );
                    _controller.clear();

                    if (response.statusCode == 200) {
                      // final res = jsonDecode(utf8.decode(response.bodyBytes));
                      // print(res);
                    }
                    else {
                      throw Exception("Failed to write the comment");
                    }

                    setState(() {
                        
                    });
                  },
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.start,
                  // controller: _controller,
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
    );
  }
}

class OneComment extends StatelessWidget {
  const OneComment({
    required this.uname,
    required this.avatar,
    required this.comment,
    Key? key
  }) : super(key: key);

  final String uname;
  final String avatar;
  final String comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20.w,),
            SizedBox(
              width: 45.w,
              height: 45.w,
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.memory(
                    base64Decode(avatar),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(uname, style: TextStyle(fontSize: 17.sp,),),
            ),
          ],
        ),
        Center(child: Text(comment, style: TextStyle(fontSize: 17.sp,),)),
        SizedBox(height: 10.h,),
      ],
    );
  }
}

class OnePost extends StatelessWidget {
  const OnePost({
    required this.name,
    required this.avatar,
    required this.aid,
    required this.content,
    required this.photo,
    required this.likes,
    Key? key
  }): super(key: key);

  final String name;
  final String avatar;
  final String aid;
  final RichText content;
  final String photo;
  final int likes;

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
              SizedBox(
                width: 45.w,
                height: 45.w,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.memory(
                      base64Decode(avatar),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(name, style: TextStyle(fontSize: 18.sp),),
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
                    Image.memory(
                      base64Decode(photo),
                      width: 173.w,
                      height: 173.w,
                    ),
                    SizedBox(height: 10.h,),
                    content,
                    
                    // liked
                    LikesInformation(likes: likes,),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Comments(aid: aid),
        ],
      ),
    ); 
  }
}

class LikesInformation extends StatefulWidget {
  const LikesInformation({
    Key? key,
    required this.likes
  }) : super(key: key);

  final int likes;

  @override
  State<LikesInformation> createState() => _LikesInformationState();
}

class _LikesInformationState extends State<LikesInformation> {
  bool _hasLiked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("${widget.likes} x  "),
        InkWell(
          child: _hasLiked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
          onTap: () => setState(() {
            // TODO: Update likes to backend
            _hasLiked = !_hasLiked;
          }) 
        ),
      ],
    );
  }
}

class WordCard extends StatefulWidget {
  const WordCard({
    Key? key,
    required this.word,
  }) : super(key: key);

  final String word;

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  final _soundPlayer = SoundPlayer();
  
  @override
  void initState() {
    super.initState();
    _soundPlayer.init();
  }

  @override
  void dispose() {
    super.dispose();
    _soundPlayer.dispose();
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
    return AlertDialog(
      content: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.word),
            InkWell(
              child: Icon(Icons.volume_up_rounded),
              onTap: () async {
                await Text2Speech().connect(play, widget.word, "female");
              },
            ),
          ],
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
  final TextEditingController _controller = TextEditingController();
  final List<String> exampleContent = <String>["今天", "天氣", "真好"];
  final _soundRecorder = SoundRecorder();
  String? _image;

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
                  children: [
                    SizedBox(height: 100.h,),
                    // image pre-view
                    Container(
                      child: _image != null ? Image.file(io.File(_image!)) : null,
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
                        hintMaxLines: 2,
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
                    final ImagePicker picker = ImagePicker();
                    final imageFromGallery =
                        await picker.pickImage(source: ImageSource.gallery);
                    CroppedFile? croppedImage = await ImageCropper().cropImage(
                      sourcePath: imageFromGallery!.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                      ],
                    );
                    if (croppedImage != null) {
                      setState(() {
                        _image = croppedImage.path;
                      });
                    }
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
                      // TODO: pass family names to widget and send their fid to backend
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
                      onPressed: () async {
                        if (_image == null) {
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
                          final url = Uri.parse("http://140.116.245.146:8000/post");
                          final request = http.MultipartRequest("POST", url);
                          request.fields["uid"] = PersonInfo.uid;
                          request.fields["content"] = _controller.text;
                          request.fields["visibility"] = "0";
                          request.files.add(await http.MultipartFile.fromPath("photo", _image!));
                          request.send().then((response) async {
                            // print(jsonDecode(await response.stream.bytesToString()));
                          });
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () => Navigator.pop(context, true)
                          );
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
              io.Directory tempDir = await path_provider.getTemporaryDirectory();
              String path = '${tempDir.path}/content.wav';
              await _soundRecorder.toggleRecording(path);
              if (!_soundRecorder.isRecording) {
                await Speech2Text().connect(path, (text) => _controller.text += ('$text\n'), "Minnan");
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}