import 'package:famistory/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysql_client/mysql_client.dart';

import '../widgets/widgets.dart';
import 'describe.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final String photo = "assets/images/famistory.png";

  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

      return Stack(
              children: [
                Container(color: const Color.fromARGB(51, 255, 220, 107)),
                Scaffold(
                  body: Center(
                  child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(width: 3.w, height: 123.h,),
                      SizedBox(
                        width: 185.w,
                        height: 173.h,
                        child: Image.asset(photo),
                      ),
                      SizedBox(width: 3.w, height: 65.h,),
                      Text("登入帳號", style: TextStyle(
                          fontSize: 28.sp, fontWeight: FontWeight.bold),),
                      SizedBox(width: 3.w, height: 30.h,),
                      LoginInputField(
                        title: '帳號',
                        controller: _accountController,
                        inputState: 0,
                      ),
                      SizedBox(width: 3.w, height: 20.h,),
                      LoginInputField(
                        title: '密碼',
                        controller: _passwordController,
                        inputState: 1,
                      ),
                      SizedBox(width: 3.w, height: 68.h,),
                      RoundedRectElevatedButton(
                        backgroundColor: const Color(0xffffd66b),
                        fixedSize: Size(150.w, 50.h),
                        onPressed: () async {
                            if (_accountController.text.toString() == "" &&
                                _passwordController.text.toString() != "") {
                              setState(() {
                                isValid[0] = false;
                                isValid[1] = true;
                              });
                            }
                            else if (_accountController.text.toString() != "" &&
                                _passwordController.text.toString() == "") {
                              setState(() {
                                isValid[0] = true;
                                isValid[1] = false;
                              });
                            }
                            else if (_accountController.text.toString() == "" &&
                                _passwordController.text.toString() == "") {
                              setState(() {
                                isValid[0] = false;
                                isValid[1] = false;
                              });
                            }
                            else {
                              // connect to database
                              final conn = await MySQLConnection
                                  .createConnection(
                                host: "140.116.245.146",
                                port: 3308,
                                userName: "famistory",
                                password: "ofwgjyyi",
                                databaseName: "famistory", // optional
                              );
                              await conn.connect();
                              var result = await conn.execute(
                                  "SELECT * FROM users WHERE acc = :acc and pwd = :pwd",
                                  {
                                    "acc": _accountController.text.toString(),
                                    "pwd": _passwordController.text.toString()
                                  });

                              if (result.rows.isNotEmpty) {
                                setState(() {
                                  isValid[0] = true;
                                  isValid[1] = true;
                                });
                                if (!mounted) return;
                                // navigate to next page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MainPage())
                                );
                              }
                              else {
                                result = await conn.execute(
                                    "SELECT * FROM users WHERE acc = :acc",
                                    {
                                      "acc": _accountController.text.toString()
                                    });
                                if (result.rows.isNotEmpty) {
                                  setState(() {
                                    isValid[0] = true;
                                    isValid[1] = false;
                                  });
                                }
                                else {
                                  setState(() {
                                    isValid[0] = false;
                                    isValid[1] = true;
                                  });
                                }
                              }

                              print(result.rows.length);
                              for (final row in result.rows) {
                                print(row.assoc());
                              }
                            }
                          },
                        child: Text("登入", style: smallTextStyle),
                      ),
                      SizedBox(
                        width: 150.w,
                        height: 30.h,
                      child: SizedBox(
                          width: 150.w,
                          height: 18.h,
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                  child: const Text('還沒建立帳號嗎? 註冊'),
                                  onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const DescribePage())
                                    );
                                    }
                                  )
                          )
                      )
                      )
                    ],
                  )
                  )
                  )
                )
              ]
          );
  }
}