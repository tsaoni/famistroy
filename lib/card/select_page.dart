// flutter package
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// my package
import 'package:famistory/card/select_card.dart';

// global access variable
final chiptheme = ['冷笑話', '愛情', '運動', '政治', '新冠肺炎'];
var chipselect = [0, 0, 0, 0, 0];
int theme_num = 5;


class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {

  Set<String> _getSelected(){
    Set<String> set = {};
    for(int i = 0; i < theme_num; i++){
      if(chipselect[i] == 1) {
        set.add(chiptheme[i]);
        chipselect[i] = 0;
      }
    }
    return set;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("選擇有興趣的主題吧!", style: TextStyle(fontSize: 28.sp),),
            Column(
              children: [
                 SizedBox(
                 width: 300.w,
                 height: 200.h,
                 child: Align(
                   alignment: const Alignment(0.5, 0.9),
                   child:
                         Row(
                              children: [
                                ActionChip(
                                  label: Text(chiptheme[0], style: TextStyle(fontSize: 17.sp),),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                  onPressed: (){ setState(() => chipselect[0] = (chipselect[0] + 1) % 2); },
                                  backgroundColor: chipselect[0] == 0 ? Colors.white:Colors.yellow,
                                ),
                                ActionChip(
                                  label: Text(chiptheme[1], style: TextStyle(fontSize: 17.sp),),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                  onPressed: (){ setState(() => chipselect[1] = (chipselect[1] + 1) % 2); },
                                  backgroundColor: chipselect[1] == 0 ? Colors.white:Colors.yellow,
                                ),
                                ActionChip(
                                  label: Text(chiptheme[2], style: TextStyle(fontSize: 17.sp),),
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.black),
                                  onPressed: (){ setState(() => chipselect[2] = (chipselect[2] + 1) % 2); },
                                  backgroundColor: chipselect[2] == 0 ? Colors.white:Colors.yellow,
                                )
                              ],
                            )
                        )
                    ),
                SizedBox(
                    width: 300.w,
                    height: 200.h,
                    child: Align(
                        alignment: const Alignment(0.5, -0.7),
                        child: Row(
                          children: [
                              ActionChip(
                                label: Text(chiptheme[3], style: TextStyle(fontSize: 17.sp),),
                                labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                onPressed: (){ setState(() => chipselect[3] = (chipselect[3] + 1) % 2); },
                                backgroundColor: chipselect[3] == 0 ? Colors.white:Colors.yellow,
                              ),
                              ActionChip(
                                label: Text(chiptheme[4], style: TextStyle(fontSize: 17.sp),),
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.black),
                                onPressed: (){ setState(() => chipselect[4] = (chipselect[4] + 1) % 2); },
                                backgroundColor: chipselect[4] == 0 ? Colors.white:Colors.yellow,
                              )
                            ],
                          )
                          )
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => SelectCard(_getSelected()),
                            ),
                            );
                          },
                          child: Card(
                              elevation: 8,
                              color: Colors.amber.shade300,
                              child: SizedBox(
                                width: 150.w,
                                height: 50.w,
                                child: Center(child: Text("確認", style: TextStyle(fontSize: 17.sp),)),
                              )
                          ),
                        ),
                      ],
                    )
          ],
        ),
      ),
    );
  }
}

