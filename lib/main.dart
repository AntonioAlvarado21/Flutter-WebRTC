//import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'package:camera/camera.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'WebRTC with Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Declarate Video Render
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  //Colocate Video Render
  @override
  dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  //Inicializar State
  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  //Inicializar Render
  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
    super.initState();
  }

  //Metodo GetUserMedia
  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      },
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
  }

  SizedBox titles() => SizedBox(
        height: 30,
        child: Row(children: [
          Flexible(
              child: Container(
                key: const Key('text_local'),
                margin: const EdgeInsets.fromLTRB(150, 5.0, 150, 5.0),
                child: const Text('Video Local'), 
            )
          ),
          Flexible(
              child: Container(
                key: const Key('text_remote'),
                margin: const EdgeInsets.fromLTRB(250, 5.0, 0, 5.0),
                child: const Text('Video remoto'),
          )
        ),
      ]),
  );

  SizedBox videoRenderers() => SizedBox(
        height: 420,
        child: Row(children: [
          Flexible(
              child: Container(
                key: const Key('local'),
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: const BoxDecoration(color: Colors.black),
                child: RTCVideoView(_localRenderer), 
            )
          ),
          Flexible(
              child: Container(
                key: const Key('remote'),
                margin: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                decoration: const BoxDecoration(color: Colors.black),
                child: RTCVideoView(_remoteRenderer),
          )
        ),
      ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(children: [
            titles(),
            videoRenderers(),
            // offerAndAnswerButtons(),
            // sdpCandidateTF(),
            // sdpCandidateButtons(),
          ]),
        ));
  }
}
