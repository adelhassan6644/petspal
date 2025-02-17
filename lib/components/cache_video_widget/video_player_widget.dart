import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zurex/app/core/videos.dart';
import 'package:video_player/video_player.dart';

import '../../app/core/styles.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? filePath;
  const VideoPlayerWidget({super.key, this.filePath});
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
        File(widget.filePath ?? Videos.welcomeVideo));

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _controller.value.isInitialized
          ? VideoPlayer(_controller)
          : const Center(
              child: SpinKitThreeBounce(
                color: Styles.WHITE_COLOR,
                size: 25,
              ),
            ),
    );
  }
}
