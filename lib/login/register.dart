import 'package:famistory/login/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mysql_client/mysql_client.dart';

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
  bool birthday_valid = true;

  List <TextEditingController> controllers = [TextEditingController(), TextEditingController(), TextEditingController(),
    TextEditingController(), TextEditingController()];

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
        controllers[4].text = selectedDate.toString().substring(0, 10);
      });
    }
  }

  String generate_id(int user_num){
    return (user_num - 1).toString().padLeft(8, '0');
  }
  
  @override
  Widget build(BuildContext context) {

    return Stack(
          children: [
            Container(color: const Color.fromARGB(51, 255, 220, 107)),
            Scaffold(
              body: Form(
                key: _formKey,
                child: Center(
                child: SingleChildScrollView(
                      child: Column(
                      children: <Widget>[
                        SizedBox(
                            width: 200.w,
                            height: 180.h,
                            child: Align(
                                alignment: Alignment.center,
                                child: Text("建立帳戶", style: TextStyle(
                                    fontSize: 28.sp, fontWeight: FontWeight.bold),)
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 81.h,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: LoginInputField(title: '帳號', controller: controllers[0], inputState: 2,)
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 81.h,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: LoginInputField(title: '密碼', controller: controllers[1], inputState: 3,)
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 81.h,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: LoginInputField(title: '再輸入一次密碼', controller: controllers[2], inputState: 4,)
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 81.h,
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: LoginInputField(title: '姓名', controller: controllers[3], inputState: 5,)
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 25.h,
                            child:
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("生日", style: TextStyle(
                                    fontSize: 18.sp, color: grey)
                                )
                            )
                        ),
                        Container(
                            width: 200.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: birthday_valid ? grey: Colors.red,
                                  width: 3.w,
                                ),
                                borderRadius: BorderRadius.circular(10.r)
                            ),
                            child: SizedBox(
                                width: 150.w,
                                height: 20.h,
                                child: TextField(
                                  controller: controllers[4],
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),//editing controller of this TextField
                                  readOnly: true, //set it true, so that user will not able to edit text
                                  onTap: () => _selectDate(context),
                                )
                            )
                        ),
                        SizedBox(width: 20.w, height: 10.h,),
                        SizedBox(
                            width: 200.w,
                            height: 25.h,
                            child:
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text("性別", style: TextStyle(
                                    fontSize: 18.sp, color: grey)
                                )
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 42.h,
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
                            )
                        ),
                        SizedBox(
                            width: 200.w,
                            height: 100.h,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: RoundedRectElevatedButton(
                                backgroundColor: const Color(0xffffd66b),
                                fixedSize: Size(150.w, 50.h),
                                onPressed: () async {
                                  bool pass = true;
                                  setState((){
                                    for(int i = 0; i < 4; i++){
                                      if(controllers[i].text.toString() == ""){
                                        pass = false;
                                        isValid[i + 2] = false;
                                      }
                                      else{
                                        isValid[i + 2] = true;
                                      }
                                    }
                                    // check second typed password same as the first
                                    if(controllers[1].text.toString() != controllers[2].text.toString()){
                                      isValid[4] = false;
                                      pass = false;
                                    }
                                    // authentication on birthday input
                                    if(controllers[4].text.toString() == ""){
                                      birthday_valid = false;
                                      pass = false;
                                    }
                                    else{
                                      birthday_valid = true;
                                    }
                                  });
                                  if(pass) {
                                    // insert data into database
                                    final conn = await MySQLConnection.createConnection(
                                      host: "140.116.245.146",
                                      port: 3308,
                                      userName: "famistory",
                                      password: "ofwgjyyi",
                                      databaseName: "famistory", // optional
                                    );
                                    await conn.connect();
                                    var stmt = await conn.prepare(
                                      "INSERT INTO users (uid, acc, pwd, gender, birth, uname) VALUES (?, ?, ?, ?, ?, ?)",
                                    );
                                    var result = await conn.execute("SELECT * FROM users");
                                    await stmt.execute([generate_id(result.rows.length), controllers[0].text.toString(), controllers[1].text.toString(), dropdownValue, controllers[4].text.toString(), controllers[3].text.toString()]);
                                    await stmt.deallocate();
                                    result = await conn.execute("SELECT * FROM users");
                                    for (final row in result.rows) {
                                      print(row.assoc());
                                    }

                                    if (!mounted) return;
                                    // navigate to next page
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const UploadPage())
                                    );
                                  }

                                  },
                                child: Text("建立", style: smallTextStyle),
                              ),
                            )
                        )
                      ],
                    ),
                  )
                )
              )
            )
          ]
      );
  }
}