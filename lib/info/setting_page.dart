import 'package:flutter/material.dart';

class GroupSettingPage extends StatefulWidget {
  const GroupSettingPage({ Key? key }) : super(key: key);

  @override
  State<GroupSettingPage> createState() => Group_SettingPageState();
}

class Group_SettingPageState extends State<GroupSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Group setting page")),
    );
  }
}