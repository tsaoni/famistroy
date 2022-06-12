import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:famistory/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';

class SoundPlayer {
  final FlutterSoundPlayer _soundPlayer = FlutterSoundPlayer();
  bool _isInitialized = false;
  bool isPlaying = false;

  Future init() async {
    print("sound player init");
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

class SoundRecorder {
  final FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialised = false;
  // bool get isRecording => _soundRecorder.isRecording;
  bool isRecording = false;

  Future init() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Micorphone permission denied');
    }
    await _soundRecorder.openRecorder();
    _isRecorderInitialised = true;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;
    _soundRecorder.closeRecorder();
    _isRecorderInitialised = false;
  }

  Future _record(path) async {
    if (!_isRecorderInitialised) return;
    await _soundRecorder.startRecorder(toFile: path);
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    await _soundRecorder.stopRecorder();
  }

  Future toggleRecording(path) async {
    if (_soundRecorder.isStopped) {
      await _record(path);
    } else {
      await _stop();
    }
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

class Speech2Text {
  //若透過Android手機傳送，則設為"A"；若透過網頁傳送，則設為"W"
  final String label = "A";
  final serviceId = "0001";

  final String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJpZCI6NzgsInVzZXJfaWQiOiIwIiwic2VydmljZV9pZCI6IjMiLCJzY29wZXMiOiI5OTk5OTk5OTkiLCJzdWIiOiIiLCJpYXQiOjE1NDEwNjUwNzEsIm5iZiI6MTU0MTA2NTA3MSwiZXhwIjoxNjk4NzQ1MDcxLCJpc3MiOiJKV1QiLCJhdWQiOiJ3bW1rcy5jc2llLmVkdS50dyIsInZlciI6MC4xfQ.K4bNyZ0vlT8lpU4Vm9YhvDbjrfu_xuPx8ygoKsmovRxCCUbj4OBX4PzYLZxeyVF-Bvdi2-wphGVEjz8PsU6YGRSh5SDUoHjjukFesUr8itMmGfZr4BsmEf9bheDm65zzbmbk7EBA9pn1TRimRmNG3XsfuDZvceg6_k6vMWfhQBA";

  Future connect(String path, void Function(String) handler, String language) async {
    String modelname = language + "\u0000\u0000";
    String outmsg = token + "@@@" + modelname + label + serviceId;
    List<int> outmsgByte = utf8.encode(outmsg);
    List<int> waveByte = await convert(path);
    List<int> outbyte = byteconcate(outmsgByte, waveByte);

    var g = Uint32List(4);
    g[0] = (outbyte.length & 0xff000000) >>> 24;
    g[1] = (outbyte.length & 0x00ff0000) >>> 16;
    g[2] = (outbyte.length & 0x0000ff00) >>> 8;
    g[3] = (outbyte.length & 0x000000ff);

    await Socket.connect("140.116.245.149", 2804).then((socket) {
      print('---------Successfully connected------------');
      socket.add(byteconcate(g, outbyte));
      socket.flush();
      socket.listen((dataByte) {
        print('-------Data from socket-------');
        var dataString = utf8.decode(dataByte);
        // 因為dart中Map中的引號是雙引號,但回傳的json格式是單引號，所以會報錯=>需要轉換
        Map respone = jsonDecode(dataString.replaceAll("'", '"'));
        print(respone['rec_result']);
        final taiTxt = respone['rec_result'][0];
        handler(taiTxt);
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

  Future<List<int>> convert(path) async {
    var file = File(path);
    var bytes = await file.readAsBytes();
    return bytes;
  }
}

Future<void> copy2Clipboard(BuildContext context, String text) async {
  await Clipboard.setData(
    ClipboardData(text: text)).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已複製到剪貼簿'),
          action: SnackBarAction(label: "OK", onPressed: () => {}),
        )
      );
    }
  );
}

Future<void> showSomeMessage(BuildContext context, String text) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      action: SnackBarAction(onPressed: () {}, label: "OK",),
    )
  );
}