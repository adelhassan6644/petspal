// import 'dart:developer';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:record_platform_interface/src/types/audio_encoder.dart';
// import 'package:zurex/app/core/app_state.dart';
// import 'package:zurex/features/chat/bloc/chat_bloc.dart';
// import 'package:zurex/features/chat/repo/chat_repo.dart';
// import 'package:zurex/features/chat/bloc/upload_chat_file_bloc.dart';
// import 'package:zurex/helpers/permissions.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
//
// import '../../../../app/core/app_event.dart';
// import '../../../../app/core/styles.dart';
// import '../../../../app/core/svg_images.dart';
// import '../../../../components/custom_images.dart';
// import '../../../../data/config/di.dart';
//
// class RecordingButton extends StatefulWidget {
//   const RecordingButton({super.key, this.onRecord});
//
//   final Function(String)? onRecord;
//
//   @override
//   State<RecordingButton> createState() => _RecordingButtonState();
// }
//
// class _RecordingButtonState extends State<RecordingButton> {
//   String? recordFilePath;
//   final record = AudioRecorder();
//   Future _getPath() async {
//
//     String customPath = '/flutter_audio_recorder_';
//     Directory appDocDirectory;
//     if (Platform.isIOS) {
//       appDocDirectory = await getApplicationDocumentsDirectory();
//     } else {
//       appDocDirectory = (await getExternalStorageDirectory())!;
//     }
//
//     // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//     customPath = "${appDocDirectory.path}$customPath${DateTime.now().millisecondsSinceEpoch}.flac";
//
//
//     return  customPath;
//
//   }
//   @override
//   void initState() {
//
//     super.initState();
//   }
//
//   void startRecord() async {
//
//
//        recordFilePath = await _getPath();
//
//     // / Check and request permission if needed
//     if (await record.hasPermission()) {
//     // Start recording to file
//     await record.start( const RecordConfig(encoder: AudioEncoder.flac), path: recordFilePath!);
//     }
//
//
//     // }
//
//
//   }
//
//   void stopRecord() async {
//     final path = await record.stop();
//
//
//
//
//     {
//       recordFilePath=path;
//       context.read<ChatBloc>().updateIsRecording(false);
//       recordFilePath = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => UploadChatFileBloc(repo: sl<ChatRepo>()),
//       child: BlocBuilder<UploadChatFileBloc, AppState>(
//         builder: (context, state) {
//           return StreamBuilder<bool?>(
//               stream: context.read<ChatBloc>().isRecordingStream,
//               builder: (_, snapshot) {
//                 return GestureDetector(
//                   onTap: () async {
//                     // await PermissionHandler.checkFilePermission();
//                     await PermissionHandler.checkMicrophonePermission();
//                   },
//                   onLongPress: () async {
//                     if (
//                         await PermissionHandler.checkMicrophonePermission()) {
//                       context.read<ChatBloc>().updateIsRecording(true);
//                       startRecord();
//                     }
//                   },
//                   onLongPressEnd: (details) async {
//                     if (
//                         await PermissionHandler.checkMicrophonePermission()) {
//                       context.read<UploadChatFileBloc>().add(Click(arguments: {
//                             "path": recordFilePath,
//                             "operation": widget.onRecord
//                           }));
//                       stopRecord();
//                     }
//                   },
//                   child: snapshot.data == true
//                       ? const Icon(
//                           Icons.fiber_smart_record,
//                           size: 24,
//                           color: Styles.PRIMARY_COLOR,
//                         )
//                       : customImageIconSVG(
//                           imageName: SvgImages.mic,
//                           width: 24,
//                           height: 24,
//                           color: Styles.PRIMARY_COLOR,
//                         ),
//                 );
//               });
//         },
//       ),
//     );
//   }
// }
