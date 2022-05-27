// flutter
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my library
import 'package:famistory/card/question_answer.dart';

String theme = "";
String index = "";
bool micro_on = false;

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
        body: Column(
          children: [
            Center(
              child:
                SizedBox(
                  width: 300.w,
                  height: 100.h,
                  child: Center(
                        child: Text(questions[theme]![index]!.title,
                                    style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                )
                      ),
                ),
            ),
            Center(
              child:
                SizedBox(
                    width: 300.w,
                    height: 150.h,
                    child: Center(
                        child: Text("可以試著說:\n${questions[theme]![index]!.question}",
                          style: TextStyle(fontSize: 17.sp),
                          textAlign: TextAlign.center,
                        )
                    )
                )
            ),
            SizedBox(
              width: 337.w,
              height: 400.h,
              child:
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Card(
                        color: micro_on ? const Color(0xffffd66b): Colors.transparent,
                        elevation: 0,
                        child: SizedBox(
                            width: 337.w,
                            height: 283.h
                        )
                    )
                  )
            )
       ]
        ),
        floatingActionButton: SizedBox(
            width: 147.w,
            height: 147.h,
            child: FittedBox(
                      child:
                        FloatingActionButton(
                            backgroundColor: Colors.white,
                            foregroundColor: micro_on ? Colors.red:Colors.black,
                            elevation: 5,
                            onPressed: () async {
                              setState(() {
                                micro_on = !micro_on;
                              });
                            },
                            //tooltip: 'Increment',
                            child: const Icon(Icons.mic_outlined, size: 48,),
                        )
                    )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
