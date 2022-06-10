// flutter
import 'package:famistory/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  final TextEditingController _controller = TextEditingController();

  stt.SpeechToText speech = stt.SpeechToText();

  bool _speechEnabled = false;
  bool _repeat = false;
  bool _isOn = false;
  
  Future<void> _startListening() async {
    _repeat = false;
    await speech.listen(onResult: _onSpeechResult,);
    setState(() {});
  }
    // 初始化的func
  void _initSpeech() async {
    _speechEnabled = await speech.initialize(
      debugLogging: true,
    );
    setState(() {});
  }
    // 把結果append到textfield的func
  void _onSpeechResult(result) {
    if (speech.isNotListening && _repeat == false) {
      setState(() {
        _repeat = true;
        _controller.text += result.recognizedWords + '，';
        _isOn =  false;
      });
    }
  }
    // 停止聆聽的func不過似乎用不太到 用於timeout的時候
  Future<void> _stopListening() async {
    await speech.stop();
    setState(() {
      _repeat = false;
    });
  }
    // 下方按鈕按下去要執行的func
  void listen() async {
    if (_speechEnabled) {
      _isOn = true;
      speech.isNotListening ? await _startListening() : await _stopListening();
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
            children: [
              Container(color: const Color.fromARGB(51, 255, 220, 107),),
              Column(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(20.r)
                      ),
                      // color: yellow,
                      width: 337.w,
                      height: 283.h,
                      child: TextField(
                        controller: _controller,
                        maxLines: 100,
                        decoration: InputDecoration(
                          hintStyle: smallTextStyle,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                        ),
                      ),
                    ),
                  ],
                )
           ]
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
                            foregroundColor: _isOn ? Colors.red:Colors.black,
                            elevation: 5,
                            onPressed: () async {
                              listen();
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
