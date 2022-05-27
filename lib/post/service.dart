import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class SoundPlayer {
  final FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();
  bool _isInitialized = false;
  bool isPlaying = false;

  Future init() async {
    await _soundPlayer.openPlayer();
    _isInitialized = true;
  }

  Future dispose() async {
    if (!_isInitialized) return;
    await _soundPlayer.closePlayer();
    _isInitialized = false;
  }

  Future play(String pathToAudio) async {
    if (!_isInitialized) return;
    await _soundPlayer.startPlayer(
      fromURI: pathToAudio,
    );
  }

  Future stop() async {
    if (!_isInitialized) return;
    await _soundPlayer.closePlayer();
  }

}

class Text2Speech {

  List<int> data = [];
  bool socketStatus = false;
  final String token =
      "eyJhbGciOiJSUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ3bW1rcy5jc2llLmVkdS50dyIsInNlcnZpY2VfaWQiOiIxNyIsIm5iZiI6MTU3ODE5MzUwNSwic2NvcGVzIjoiMCIsInVzZXJfaWQiOiI4OCIsImlzcyI6IkpXVCIsInZlciI6MC4xLCJpYXQiOjE1NzgxOTM1MDUsInN1YiI6IiIsImlkIjoyNTUsImV4cCI6MTczNTg3MzUwNX0.r2bOx3KpZ2JhFq-QAMnKncMSIjOVRjF4vHF8VlIVx6S4jGgHqnW9075xBFNC-Cl6P7xhnVxdzgME9mSB6G3iUy_DfsdjUXUTUpxaNfgWmVIEpBz3r0_glUGccxEd154-zuFNffqs8oSEMCdoivYMzYG2v_lNjMjXwryHU3JrV5g";

  Future connect(void Function(String) player, String strings, [String inputModel = 'man']) async {
    String model = inputModel;
    if (inputModel == "man") {
      model = "M12";
    } else if (inputModel == "female") {
      model = "F14_sandhi";
    }

    String outmsg = token + "@@@" + strings + "@@@" + model;

    List<int> outbyte = utf8.encode(outmsg);

    var g = Int32List(4);
    // little endian to big endian
    g[0] = ((outbyte.length & 0xff000000) >>> 24);
    g[1] = ((outbyte.length & 0x00ff0000) >>> 16);
    g[2] = ((outbyte.length & 0x0000ff00) >>> 8);
    g[3] = ((outbyte.length & 0x000000ff));

    await Socket.connect("140.116.245.146", 10012).then((socket) async {
      socket.add(byteconcate(g, outbyte));
      socket.flush();
      socket.listen((dataByte) async {
        data = byteconcate(data, dataByte);
      }, onDone: () async {
        socket.destroy();
        Directory tempDir = await path_provider.getTemporaryDirectory();
        String pathToReadAudio = '${tempDir.path}/word.wav';
        var file = File(pathToReadAudio);
        await file.writeAsBytes(data, flush: true);
        player(pathToReadAudio);
      });
    }).catchError((e) {
      print("socket無法連接: $e");
    });
  }

  List<int> byteconcate(List<int> a, List<int> b) {
    List<int> result = Int32List(a.length + b.length);

    result.setRange(0, a.length, a, 0);
    result.setRange(a.length, a.length + b.length, b,0);

    return result;
  }
}
