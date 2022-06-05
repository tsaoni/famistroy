import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalSettingPage extends StatefulWidget {
  const PersonalSettingPage({Key? key}) : super(key: key);

  @override
  State<PersonalSettingPage> createState() => _PersonalSettingPageState();
}

class _PersonalSettingPageState extends State<PersonalSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Personal setting page")),
    );
  }
}

class GroupSettingPage extends StatefulWidget {
  const GroupSettingPage({ Key? key }) : super(key: key);

  @override
  State<GroupSettingPage> createState() => _GroupSettingPageState();
}

class _GroupSettingPageState extends State<GroupSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("Group setting page")),
    );
  }
}