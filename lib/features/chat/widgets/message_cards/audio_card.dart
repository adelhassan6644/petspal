import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zurex/app/core/text_styles.dart';
import '../../../../app/core/styles.dart';
import '../../model/message_model.dart';

class AudioCard extends StatefulWidget {
  final MessageItem message;

  const AudioCard({super.key, required this.message});

  @override
  AudioCardState createState() => AudioCardState();
}

class AudioCardState extends State<AudioCard> {
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Future<void> _getAudioDuration() async {
    duration =
        await audioPlayer.setUrl(widget.message.message ?? "") ?? Duration.zero;
    setState(() {});
  }

  Future<void> initialization() async {
    audioPlayer = AudioPlayer();
  }

  @override
  void initState() {
    initialization();
    _getAudioDuration();

    audioPlayer.durationStream.listen((v) {
      if (mounted) setState(() => duration = v ?? Duration.zero);
    });

    audioPlayer.positionStream.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    if (Platform.isAndroid) {
      audioPlayer.setVolume(1);
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
        stream: audioPlayer.playerStateStream,
        builder: (context, snapshot) {
          if (snapshot.data?.processingState == ProcessingState.completed) {
            audioPlayer.seek(Duration.zero);
            audioPlayer.stop();
          }
          return SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Slider(
                            value: position.inMicroseconds.toDouble(),
                            max: duration.inMicroseconds.toDouble()+1,
                            thumbColor: widget.message.isMe == true
                                ? Styles.HINT_COLOR
                                : Styles.PRIMARY_COLOR,
                            activeColor: widget.message.isMe == true
                                ? Styles.HINT_COLOR
                                : Styles.PRIMARY_COLOR,
                            inactiveColor: Styles.WHITE_COLOR,
                            min: 0,
                            onChanged: (double value) {
                              audioPlayer
                                  .seek(Duration(microseconds: value.round()));
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Text(
                        "${formatDuration(position)} / ${formatDuration(duration)}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 10,
                            color: widget.message.isMe == true
                                ? Styles.HINT_COLOR
                                : Styles.PRIMARY_COLOR),
                      )
                    ],
                  ),
                ),
                (snapshot.data == null ||
                        snapshot.data?.processingState ==
                            ProcessingState.buffering)
                    ? CupertinoActivityIndicator(
                        color: widget.message.isMe == true
                            ? Styles.HINT_COLOR
                            : Styles.PRIMARY_COLOR,
                      )
                    : IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                            size: 35,
                            (snapshot.data?.playing == true)
                                ? Icons.pause_circle_filled_outlined
                                : Icons.play_circle_fill_outlined,
                            color: widget.message.isMe == true
                                ? Styles.HINT_COLOR
                                : Styles.PRIMARY_COLOR),
                        onPressed: () {
                          if (snapshot.data?.playing == true) {
                            audioPlayer.pause();
                          } else {
                            audioPlayer.play();
                          }
                          setState(() {});
                        },
                      )
              ],
            ),
          );
        });
  }
}
