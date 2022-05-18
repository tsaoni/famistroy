import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:famistory/card/select_card.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String dropdownValue = "冷笑話";
  bool _hasSelected = false;
  final topics = [    
    '冷笑話',
    '愛情',
    '運動',
    '政治',
    '新冠肺炎',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("請選擇主題", style: TextStyle(fontSize: 28.sp),),
            DropdownButton(
              hint: _hasSelected ? null : const Text("選擇主題"),
              value: _hasSelected ? dropdownValue : null,
              icon: const Icon(Icons.keyboard_arrow_down),    
              items: topics.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) { 
                setState(() {
                  dropdownValue = newValue!;
                  _hasSelected = true;
                  Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => SelectCard({dropdownValue}),
                  ),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}