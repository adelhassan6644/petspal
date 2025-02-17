import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:zurex/data/api/end_points.dart';
import '../../data/config/di.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import 'video_player_widget.dart';

class VideoCacheManager extends StatefulWidget {
  const VideoCacheManager({super.key});

  @override
  State<VideoCacheManager> createState() => _VideoCacheManagerState();
}

class _VideoCacheManagerState extends State<VideoCacheManager> {
  late DownloadMediaBuilderController controller;

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<String>(
        stream: sl<SettingBloc>().configVideoStream,
        builder: (context, videoSnapshot) {
          if (videoSnapshot.hasData) {
            return DownloadMediaBuilder(
              url: "${EndPoints.domain}${videoSnapshot.data ?? ""}",
              onSuccess: (snapshot) {
                return VideoPlayerWidget(
                  filePath: snapshot.filePath,
                );
              },
              onLoading: (snapshot) {
                return const VideoPlayerWidget();
              },
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
