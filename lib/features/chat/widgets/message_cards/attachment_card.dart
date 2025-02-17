import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/core/svg_images.dart';
import 'package:zurex/app/localization/language_constant.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../data/config/di.dart';
import '../../../../main_blocs/download_bloc.dart';
import '../../../../main_repos/download_repo.dart';
import '../../../../components/custom_images.dart';

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({super.key, required this.url, this.isMe = true});
  final String url;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadBloc(repo: sl<DownloadRepo>()),
      child: BlocBuilder<DownloadBloc, AppState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                customImageIconSVG(
                  imageName: SvgImages.file,
                  color: Styles.PRIMARY_COLOR,
                  height: 18,
                  width: 18,
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      url.split("/").last,
                      style: AppTextStyles.w500
                          .copyWith(color: Styles.PRIMARY_COLOR, fontSize: 14),
                    ),
                    Row(
                      children: [
                        if (state is Start)
                          Text(
                            getTranslated("download"),
                            style: AppTextStyles.w500.copyWith(
                                color: Styles.PRIMARY_COLOR, fontSize: 10),
                          ),
                        if (state is Loading)
                          Text(
                            "${state.progress}/${state.total} %",
                            style: AppTextStyles.w500.copyWith(
                                color: Styles.PRIMARY_COLOR, fontSize: 10),
                          ),
                        if (state is Done)
                          Text(
                            getTranslated("downloaded"),
                            style: AppTextStyles.w500.copyWith(
                                color: Styles.PRIMARY_COLOR, fontSize: 10),
                          ),
                      ],
                    )
                  ],
                )),
                Visibility(
                  visible: state is Start || state is Error,
                  child: IconButton(
                    onPressed: () {
                      context.read<DownloadBloc>().add(Click(arguments: url));
                    },
                    icon: const Icon(
                      Icons.download,
                      size: 18,
                      color: Styles.PRIMARY_COLOR,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
