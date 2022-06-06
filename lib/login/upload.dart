import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import '../widgets/widgets.dart';






final String photo = "assets/images/personnal.png";

class UploadPage extends StatefulWidget {
    const UploadPage({super.key});

    @override
    UploadPageState createState() {
        return UploadPageState();
    }
}

class UploadPageState extends State<UploadPage> {

    final _formKey = GlobalKey<FormState>();
    String _button_word = "上傳";
    bool _text_visible = false;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
              child: Column(
                  children: [
                      const SizedBox(height: 235,),
                      SizedBox(
                          width: 247.w,
                          height: 247.h,
                          child: Image.asset(photo)
                      ),
                      SizedBox(
                          height: 150.h,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: RoundedRectElevatedButton(
                                  backgroundColor: const Color(0xffffd66b),
                                  fixedSize: Size(150.w, 50.h),
                                  onPressed: () {
                                    if(_button_word == "確認") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MainPage())
                                      );
                                    } else {
                                      setState((){
                                        _button_word = "確認";
                                        _text_visible = true;
                                      });
                                    }
                                  },
                                  child: Text(_button_word, style: smallTextStyle),
                              ),
                          )
                      ),
                    SizedBox(
                        width: 200.w,
                        height: 50.h,
                        child: Align(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                child: _text_visible? const Text('重新上傳'): const Text(''),
                                onTap: () {
                                  setState((){_button_word = "上傳";});
                                  _text_visible = false;
                                }
                            )
                        )
                    ),
                    SizedBox(
                        width: 200.w,
                        height: 50.h,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                                child: const Text('略過'),
                                onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const MainPage())
                                    );
                                }
                            )
                        )
                    ),
                  ]
              ),
          )
        );
    }

}