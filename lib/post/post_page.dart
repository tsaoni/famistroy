import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/post/service.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<OnePost> _contents = <OnePost>[];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(8.w),
        child: ListView.separated(
          itemCount: 5,
          itemBuilder: (context, index) {
            return OnePost(
              name: "user",
              avatar: "assets/images/avatar.png",
              content: RichText(
                text: TextSpan(
                  children: ["今天", "天氣", "真好"].map(
                    (word) => TextSpan(
                        text: word,
                        style: TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            showDialog(
                              context: context,
                              barrierColor: Colors.black12,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(word),
                                        InkWell(
                                          child: Icon(Icons.volume_up_rounded),
                                          onTap: () async {
                                            await Text2Speech().connect(play, word, "female");
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                            });
                          } 
                      ),
                  ).toList(),
                ),
              ),
              photo: "assets/images/photo.png",
          );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 50.h,
            thickness: 1.h,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65.w,
        height: 65.w,
        child: FittedBox(
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                final OnePost postContent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewPostPage(),
                  ),
                );
                setState(() {
                  _contents.add(postContent);
                });
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
