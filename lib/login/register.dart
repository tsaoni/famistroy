import 'package:famistory/login/upload.dart';
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
  TextEditingController dateinput = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFFFD66B), // header background color
                  onPrimary: Colors.black, // header text color
                  onSurface: Colors.black, // body text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: const Color(0xFFFFD66B), // button text color
                  ),
                ),
              ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        // String formattedDate = selectedDate.weekday.toString();
        dateinput.text = selectedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var isEmpty = true;

    return Scaffold(
      backgroundColor: const Color.fromARGB(51, 255, 220, 107),
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
                child: LoginInputField(title: '帳號',)
              )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: LoginInputField(title: '密碼',)
                )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: LoginInputField(title: '再輸入一次密碼',)
                )
            ),
            SizedBox(
                height: 81.h,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: LoginInputField(title: '姓名',)
                )
            ),
            SizedBox(
              width: 250.w,
              height: 25.h,
              child:
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("生日", style: TextStyle(
                      fontSize: 18.sp, color: Colors.grey)
                    )
                )
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: 260.w,
                  height: 42.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: grey,
                        width: 3.w,
                      ),
                      borderRadius: BorderRadius.circular(10.r)
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: TextField(
                      controller: dateinput,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),//editing controller of this TextField
                      readOnly: true, //set it true, so that user will not able to edit text
                      onTap: () => _selectDate(context),
                    )
                  )
              ),
            ),
            SizedBox(height: 10.h,),
            SizedBox(
                width: 250.w,
                height: 25.h,
                child:
                Align(
                    alignment: Alignment.topLeft,
                    child: Text("性別", style: TextStyle(
                        fontSize: 18.sp, color: Colors.grey)
                    )
                )
            ),
            SizedBox(
                width: 260.w,
                height: 42.h,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: Text('Please select group'),
                    isExpanded: true,
                    isDense: true,
                    value: dropdownValue,
                    items: const ['男', '女'].map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (selectedItem) => setState(
                          () {
                        dropdownValue = selectedItem.toString();
                      },
                    ),
                  ),
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
                        MaterialPageRoute(builder: (context) => const UploadPage())
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