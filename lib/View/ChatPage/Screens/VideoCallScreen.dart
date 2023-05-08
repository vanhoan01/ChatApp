// ignore_for_file: file_names

import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// ignore: library_prefixes
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:chatapp/Resources/app_urls.dart';
import 'package:chatapp/ViewModel/CallViewModel.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Utils/settings.dart';

//https://www.thegioididong.com/game-app/cach-goi-video-tren-facebook-messenger-bang-dien-1262983
//https://navoki.com/how-video-call-works-in-flutter-explained/

class VideoCallScreen extends StatefulWidget {
  final String caller;
  final String creceiver;
  final bool callStatus;
  const VideoCallScreen({
    Key? key,
    required this.caller,
    required this.creceiver,
    required this.callStatus,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  late RtcEngine _engine;
  // String? _token;
  CallViewModel callViewModel = CallViewModel();
  String channelName = "";
  Widget? viewUser;
  late IO.Socket socket;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    channelName = widget.caller.compareTo(widget.creceiver) > 0
        ? widget.caller + widget.creceiver
        : widget.creceiver + widget.caller;
    initialize();
    connect();
    super.initState();
    // initialize agora sdk
  }

  Future<String> getToken() async {
    String tokendt = await callViewModel.gertctoken(channelName, widget.caller);
    print("token: $tokendt");
    // setState(() {
    //   _token = data;
    // });
    return tokendt;
  }

  Future<void> initialize() async {
    String token = await getToken();
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // ignore: deprecated_member_use
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(height: 1920, width: 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    print("token join: $token");
    print("widget.channelName: ${widget.caller}");
    await _engine.joinChannelWithUserAccount(token, channelName, widget.caller);
    setState(() {
      viewUser = Center(
          child: RtcLocalView.SurfaceView(
        channelId: channelName,
      ));
    });
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  Widget _viewSubscriber() {
    if (_users.isNotEmpty) {
      return Positioned(
        top: 10,
        right: 10,
        child: SizedBox(
          height: 250,
          width: 150,
          child: RtcRemoteView.SurfaceView(
            uid: _users[0],
            channelId: channelName,
          ),
        ),
      );
    }
    return Container();
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          // RawMaterialButton(
          //   onPressed: _onSwitchCamera,
          //   shape: const CircleBorder(),
          //   elevation: 2.0,
          //   fillColor: Colors.white,
          //   padding: const EdgeInsets.all(12.0),
          //   child: const Icon(
          //     Icons.switch_camera,
          //     color: Colors.blueAccent,
          //     size: 20.0,
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return Container();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.chat_outlined),
          ),
          Expanded(child: Container()),
          IconButton(
            onPressed: _onSwitchCamera,
            icon: const Icon(Icons.cameraswitch),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          viewUser ?? Container(),
          _viewSubscriber(),
          _panel(),
          _toolbar(),
        ],
      ),
    );
  }

  Future<void> connect() async {
    socket = IO.io(AppUrl.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    // ignore: await_only_futures

    // if (socket.active == false) {
    //   // ignore: avoid_print
    //   print("Connecting");
    //   // ignore: await_only_futures
    //   await socket.connect();
    // }
    // await socket.connect();
    if (widget.callStatus) {
      print("emit calling");
      socket.emit("calling", [widget.caller, widget.creceiver]);
    }

    // socket.onConnect((data) {
    //   // ignore: avoid_print
    //   socket.on("calling", (msg) {
    //     // ignore: avoid_print
    //     print("Đối phương đã nhận cuộc gọi: $msg");
    //   });
    // });
  }
}
