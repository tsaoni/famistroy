import 'package:flutter/material.dart';

class EditPersonalInfoPage extends StatefulWidget {
  const EditPersonalInfoPage({ Key? key }) : super(key: key);

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Personal info page"),
    );
  }
}