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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.all(8.w),
        child: ListView.separated(
          itemCount: _contents.length,
          itemBuilder: (context, index) {
            return OnePost(
                name: _contents[index].name,
                avatar: _contents[index].avatar,
                // content: _contents[index].content,
                content: RichText(
                  text: TextSpan(
                    children: getClickableTextSpans(context, ["今天", "天氣", "真好"]),
                  ),
                ),
                photo: _contents[index].photo,
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
