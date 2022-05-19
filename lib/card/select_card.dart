// flutter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my library
import 'package:famistory/card/question_answer.dart';
import 'package:famistory/card/show_answer.dart';

String theme = "";

class SelectCard extends StatefulWidget {

  SelectCard(Set<String> set, {Key? key}) : super(key: key){
    theme = set.first;
  }

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {

  String _question_title(int index){
    String text = '${questions[theme]![index.toString()]?.title}/${questions[theme]![index.toString()]?.question}';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: questions[theme]!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                      return myCard({index.toString()});
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
        )
    );
  }
}

class myCard extends StatelessWidget {
  String index = "";

  myCard(Set <String> set, {Key? key}) : super(key: key) {
    index = set.first;
  }

  @override
  Widget build(BuildContext context) {
    if(index == "0") {
      return Center(
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: SizedBox(
            width: 340.w,
            height: 136.h,
            child: Center(
                child: Text(theme, style: TextStyle(fontSize: 28.sp),),
            ),
          ),
        ),
      );
    }
    else {
      int tmp = int.parse(index) - 1;
      index = tmp.toString();
      return Center(
        child: Card(
          child: SizedBox(
            width: 340.w,
            height: 136.h,
            child: ListTile(
                title: Text('${questions[theme]![index]?.title}'),
                subtitle: Text('${questions[theme]![index]?.question}'),
                onTap: () =>
                    Navigator.push(
                      context, MaterialPageRoute(
                      builder: (context) => ShowAnswer({theme, index}),
                    ),
                    )
            ),
          ),
        ),
      );
    }
  }
}