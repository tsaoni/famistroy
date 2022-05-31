import 'package:flutter/material.dart';

import 'package:famistory/info/create_page.dart';
import 'package:famistory/info/info_widget.dart';
import 'package:famistory/post/service.dart';
import 'package:famistory/widgets/widgets.dart';


class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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

  // TODO: display info depends on groups that user joined in 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Stack widget use bottom up method
        child: Stack(
          children: [// background
            Container(
              color: lightYellow,
            ),
            const InfoPageNavigationBar(),
            InfoPageBody(soundPlayer: _soundPlayer,),
            FloatingElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const CreatePage()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}