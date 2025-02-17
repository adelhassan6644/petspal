import 'package:zurex/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/components/custom_app_bar.dart';
import '../../../../data/config/di.dart';
import '../../../app/core/app_event.dart';
import '../bloc/edit_profile_bloc.dart';
import '../repo/edit_profile_repo.dart';
import '../widget/edit_profile_actions.dart';
import '../widget/edit_profile_body.dart';
import '../widget/edit_profile_header.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key, this.fromComplete = false});
  final bool fromComplete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditProfileBloc(repo: sl<EditProfileRepo>())..add(Init()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocBuilder<EditProfileBloc, AppState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditProfileHeader(fromComplete: fromComplete),
                  EditProfileBody(fromComplete: fromComplete),
                  EditProfileActions(fromComplete: fromComplete),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
