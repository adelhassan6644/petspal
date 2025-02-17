import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/features/chat/repo/chat_repo.dart';
import 'package:zurex/helpers/pickers/view/file_picker_helper.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/config/di.dart';
import '../../bloc/upload_chat_file_bloc.dart';

class VideoButton extends StatelessWidget {
  const VideoButton({super.key, this.onSelectFile});

  final Function(String)? onSelectFile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadChatFileBloc(repo: sl<ChatRepo>()),
      child: BlocBuilder<UploadChatFileBloc, AppState>(
        builder: (context, state) {
          return InkWell(
            radius: 100,
            onTap: () {
              FilePickerHelper.pickFile(
                  type: FileType.video,
                  onSelected: (v) => context.read<UploadChatFileBloc>().add(
                          Click(arguments: {
                        "path": v.path,
                        "operation": onSelectFile
                      })));
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.PRIMARY_COLOR)),
              child: state is Loading
                  ? const SpinKitThreeBounce(
                      color: Styles.PRIMARY_COLOR,
                      size: 18,
                    )
                  : const Icon(
                      Icons.video_collection,
                      size: 20,
                      color: Styles.PRIMARY_COLOR,
                    ),
            ),
          );
        },
      ),
    );
  }
}
