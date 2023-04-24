// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/Resources/app_urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessagesAudioView extends StatefulWidget {
  const MessagesAudioView({
    Key? key,
    required this.name,
    required this.size,
    this.reply,
  }) : super(key: key);
  final String name;
  final int size;
  final bool? reply;

  @override
  State<MessagesAudioView> createState() => _MessagesAudioViewState();
}

class _MessagesAudioViewState extends State<MessagesAudioView> {
  // int maxduration = 100;
  // int currentpos = 0;
  // String currentpostlabel = "00:00";
  // String audioasset = "assets/audio/red-indian-music.mp3";
  bool isplaying = false;
  bool isloading = true;
  // late Uint8List audiobytes;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      // player.onDurationChanged.listen((Duration d) {
      //   //get the duration of audio
      //   maxduration = d.inMilliseconds;
      //   setState(() {});
      // });

      player.onDurationChanged.listen((newDuration) {
        setState(() {
          duration = newDuration;
        });
      });

      player.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });

      // player.onPositionChanged.listen((Duration p) {
      //   currentpos =
      //       p.inMilliseconds; //get the current position of playing audio

      //   //generating the duration label
      //   int shours = Duration(milliseconds: currentpos).inHours;
      //   int sminutes = Duration(milliseconds: currentpos).inMinutes;
      //   int sseconds = Duration(milliseconds: currentpos).inSeconds;

      //   int rhours = shours;
      //   int rminutes = sminutes - (shours * 60);
      //   int rseconds = sseconds - (sminutes * 60 + shours * 60 * 60);

      //   currentpostlabel = "$rhours:$rminutes:$rseconds";
      // });
    });
    super.initState();
    loading();
  }

  Future<void> loading() async {
    await player.setSourceUrl(AppUrl.audioUrl + widget.name);
    setState(() {
      isloading = false;
    });
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.reply == null
          ? const Color(0xffdcf8c6)
          : widget.reply == false
              ? const Color(0xffdcf8c6)
              : Colors.grey.shade200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 25,
            child: Wrap(
              spacing: 1,
              children: [
                IconButton(
                  onPressed: () async {
                    if (isloading == false) {
                      if (!isplaying) {
                        await player.resume();
                        setState(() {
                          isplaying = true;
                        });
                      } else {
                        // print('audio: ${AppUrl.audioUrl}${widget.name}');
                        await player.pause();
                        setState(() {
                          isplaying = false;
                        });
                      }
                    }
                  },
                  icon: isloading
                      ? const SizedBox(
                          height: 10.0,
                          width: 10.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(isplaying ? Icons.pause : Icons.play_arrow),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: duration.inSeconds.toDouble(),
              activeColor: Colors.blue,
              inactiveColor: Colors.blueAccent,
              onChanged: (double value) async {
                final position = Duration(seconds: value.toInt());
                player.seek(position);
                // player.resume();
              },
            ),
          ),
          Text(
            formatTime((duration - position).inSeconds),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
