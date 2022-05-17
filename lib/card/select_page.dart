import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key}) : super(key: key);

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String dropdownValue = "主題 1";
  bool _hasSelected = false;
  final topics = [    
    '主題 1',
    '主題 2',
    '主題 3',
    '主題 4',
    '主題 5',
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
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}