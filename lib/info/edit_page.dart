import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({ Key? key }) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("EDIT PAGE")),
    );
  }
}