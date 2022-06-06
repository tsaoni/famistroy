import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../main.dart';
import '../widgets/widgets.dart';

// Define a custom Form widget.
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {

  final _formKey = GlobalKey<FormState>();
  // date picker
  DateTime selectedDate = DateTime.now();
  String dropdownValue = '男';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180.h,
              child: Align(
                      alignment: Alignment.center,
                      child: Text("建立帳戶", style: TextStyle(
                  fontSize: 28.sp, fontWeight: FontWeight.bold),)
                    )
            ),
            SizedBox(
              height: 81.h,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: OneTextInputField(title: '帳號',)
              )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: OneTextInputField(title: '密碼',)
                )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: OneTextInputField(title: '再輸入一次密碼',)
                )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: OneTextInputField(title: '姓名',)
                )
            ),
            SizedBox(
              width: 250.w,
              height: 25.h,
              child:
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("生日", style: TextStyle(
                      fontSize: 20.sp, fontWeight: FontWeight.bold)
                    )
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150.w,
                  height: 70.h,
                      child: Row(
                        children: [
                          Text("${selectedDate.toLocal()}".split(' ')[0]),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffffd66b)),
                            ),
                            onPressed: () => _selectDate(context),
                            child: const Text('選擇'),
                          )
                        ]
                      )
                )
            ),
            SizedBox(
                width: 250.w,
                height: 25.h,
                child:
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("性別", style: TextStyle(
                        fontSize: 20.sp, fontWeight: FontWeight.bold)
                    )
                )
            ),
            SizedBox(
                height: 70.h,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['男', '女']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                  )
            ),
            SizedBox(
              height: 100.h,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RoundedRectElevatedButton(
                  backgroundColor: const Color(0xffffd66b),
                  fixedSize: Size(150.w, 50.h),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainPage())
                    );
                  },
                  child: Text("建立", style: smallTextStyle),
                ),
              )
            )
          ],
        ),
      )
    );
  }
}