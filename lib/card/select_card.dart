// flutter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my library
import 'package:famistory/card/question_answer.dart';

String theme = "";
final List<int> colorCodes = <int>[600, 500, 400, 300, 200];

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
            itemCount: questions[theme]!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Colors.amber[colorCodes[index]],
                child: Center(child: Text(_question_title(index))),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
        ),
      );
  }
}