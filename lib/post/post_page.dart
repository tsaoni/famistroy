import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/post/post_widgets.dart';
import 'package:famistory/services/service.dart';

class Post {
  const Post._({
    required this.aid,
    required this.avatar,
    required this.uname,
    required this.uid,
    required this.content,
    required this.photo,
    required this.likes,
  });

  final List<String> aid;
  final List<String> uid;
  final List<String> avatar;
  final List<String> uname;
  final List<String> content;
  final List<String> photo;
  final List<int> likes;

  factory Post.fromJson(Map<String, dynamic> jsons) {
    List<String> aid = [];
    List<String> uid = [];
    List<String> avatar = [];
    List<String> uname = [];
    List<String> content = [];
    List<String> photo = [];
    List<int> likes = [];

    for (final post in jsons["posts"]) {
      aid.add(post["aid"]);
      content.add(post["content"]);
      photo.add(post["photo"]["image"]);
      likes.add(post["likes"]);
      uid.add(post["uid"]);
      uname.add(post["uname"]);
      avatar.add(post["avatar"]["image"]);
    }

    return Post._(
      aid: aid,
      avatar: avatar,
      uname: uname,
      uid: uid,
      content: content,
      photo: photo,
      likes: likes,
    );
  }
}

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late Future<Post> _post;

  Future<Post> _fetchPostInfo() async {
    final url = Uri.parse("http://140.116.245.146:8000/allpost");
    final response = await http.post(url);
    if (response.statusCode == 200) {
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      return Post.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    else {
      throw Exception("Failed to fetch data from server");
    }
  }

  @override
  void initState() {
    super.initState();
    _post = _fetchPostInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _post = _fetchPostInfo();
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _post = _fetchPostInfo();
            });
          },
          child: FutureBuilder<Post>(
            future: _post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                itemCount: snapshot.data!.aid.length,
                itemBuilder: (context, index) {
                  return OnePost(
                    name: snapshot.data!.uname[index],
                    avatar: snapshot.data!.avatar[index],
                    aid: snapshot.data!.aid[index],
                    photo: snapshot.data!.photo[index],
                    likes: snapshot.data!.likes[index],
                    content: RichText(
                      text: TextSpan(
                        children: snapshot.data!.content[index].split("/sep").map(
                          (word) => TextSpan(
                              text: word,
                              style: TextStyle(color: Colors.black, fontSize: 17.sp),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black12,
                                    builder: (context) => WordCard(word: word)
                                  );
                                }
                            ),
                        ).toList(),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 50.h,
                  color: Colors.white,
                ),
              );
              }
              else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"),);
              }
              return const CircularProgressIndicator();
            }
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65.w,
        height: 65.w,
        child: FittedBox(
            child: FloatingActionButton(
              onPressed: () async {
                final _hasNewPost = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewPostPage(),
                  ),
                );
                if (_hasNewPost) {
                  setState(() {
                    
                  });
                }
              },
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
                side: BorderSide(width: 4.w, color: const Color(0xFFFFD66B)),
              ),
              child: Icon(Icons.add, color: Colors.black, size: 40.w,),
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

