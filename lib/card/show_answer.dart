// flutter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my library
import 'package:famistory/card/question_answer.dart';

String theme = "";
String index = "";

class ShowAnswer extends StatefulWidget {

  ShowAnswer(Set<String> set, {Key? key}) : super(key: key){
    theme = set.first;
    index = set.last;
  }

  @override
  State<ShowAnswer> createState() => _ShowAnswerState();
}

class _ShowAnswerState extends State<ShowAnswer> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text('${questions[theme]![index]?.answer}')
        )
    );
  }
}
