import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/card/screens/select_page.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("抽卡介面說明", style: TextStyle(fontSize: 28.sp),),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, new MaterialPageRoute(
                      builder: (context) => new SelectPage(),
                    ),
                  );
                },
                child: Text("開始抽卡"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}