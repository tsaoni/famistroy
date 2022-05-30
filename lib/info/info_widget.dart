import 'package:famistory/post/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupComponent extends StatefulWidget {
  const GroupComponent({
    Key? key,
    required this.image,
    required this.groupName,
    required this.code
  }) : super(key: key);

  final String image;
  final String groupName;
  final String code;

  @override
  State<GroupComponent> createState() => _GroupComponentState();
}

class _GroupComponentState extends State<GroupComponent> {
  final _soundPlayer = SoundPlayer();
  
  @override
  void initState() {
    _soundPlayer.init();
    super.initState();
  }

  @override
  void dispose() {
    _soundPlayer.dispose();
    super.dispose();
  }

  Future play(String pathToAudio) async {
    await _soundPlayer.play(pathToAudio);
    setState(() {
      _soundPlayer.init();
      _soundPlayer.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.image,
            width: 100.w,
            height: 100.h,
          ),
          SizedBox(width: 20.w,),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.groupName,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  InkWell(
                    child: Icon(Icons.volume_up),
                    onTap: () async {
                      await Text2Speech().connect(play, widget.groupName, "female");
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFFD66B),
                  elevation: 5,
                  shape: StadiumBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "邀請碼: ${widget.code}",
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: const Color(0x90000000),
                      ),
                    ),
                    ImageIcon(AssetImage("assets/images/Icon-Artwork.png")),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}