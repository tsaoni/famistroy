// flutter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my library
import 'package:famistory/card/question_answer.dart';
import 'package:famistory/card/show_answer.dart';

Set themes = {};

class SelectCard extends StatefulWidget {

  SelectCard(Set<String> set, {Key? key}) : super(key: key){
    themes = set;
  }

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {

  Set <int> _starting_pos = {};
  int _card_num = 0;

  void _count_start(){
    for(var t in themes){
      _starting_pos.add(_card_num);
      _card_num += questions[t]!.length;
    }
  }

  Set<String> _get_theme(int idx){
    if (idx == -1) {
      return {"選擇一個想問的故事"};
    }
    for(int i = 0; i < themes.length; i++){
      if(idx < _starting_pos.elementAt(i)){
        return {(idx - _starting_pos.elementAt(i-1)).toString(), themes.elementAt(i-1)};
      }
    }
    return {(idx - _starting_pos.last).toString(), themes.last};
  }

  @override
  Widget build(BuildContext context) {
    _count_start();
    return Scaffold(
        body: Center(
          child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: _card_num + 1 ,
                    itemBuilder: (BuildContext context, int index) {
                                    return myCard(_get_theme(index-1));
                                  },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
          )
        )
      );
  }
}

class myCard extends StatelessWidget {
  String index = "";
  String theme = "";
  int isfirst = 0;

  myCard(Set <String> set, {Key? key}) : super(key: key) {
    index = set.first;
    theme = set.last;
    isfirst = set.length;
  }

  @override
  Widget build(BuildContext context) {
    if(isfirst == 1) {
      return Center(
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            width: 340.w,
            height: 200.h,
            child: Align(
                      alignment: Alignment.center,
                      child: ListTile(
                                title: Text(theme, style: TextStyle(fontSize: 28.sp) ),
                              )
                    ),
          ),
        ),
      );
    }
    else{
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