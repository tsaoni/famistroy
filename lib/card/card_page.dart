import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/card/select_page.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  final String photo = "assets/images/famistory.png";

  SelectPage init(){
    for(int i = 0; i < theme_num; i++){
      chipselect[i] = 0;
    }
    return const SelectPage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color.fromARGB(51, 255, 220, 107)),
        Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200.h,
                    child: Center(child: Text("話題故事館", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),)),
                  ),
                  Image.asset(photo),
                  SizedBox(
                    width: 300.w,
                    height: 160.h,
                    child: Center(
                              child: Text("話題故事館可以藉由問問題的方式，來聊聊那些你從來沒聽過的故事呦!",
                                style: TextStyle(fontSize: 14.sp),
                                textAlign: TextAlign.center)),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => init(),
                      ),
                      );
                    },
                    child: Card(
                      elevation: 8,
                      color: Colors.amber.shade300,
                      child: SizedBox(
                        width: 150.w,
                        height: 50.w,
                        child: Center(child: Text("開始遊玩", style: TextStyle(fontSize: 17.sp),)),
                      )
                    ),
                  )],
              ),
            ),
          ),
        )
      ]
    );
  }
}