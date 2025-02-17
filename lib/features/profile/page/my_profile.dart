import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:zurex/app/localization/language_constant.dart';
import 'package:zurex/components/custom_app_bar.dart';
import 'package:zurex/main_blocs/user_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../data/config/di.dart';
import '../bloc/profile_bloc.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key, this.fromNav = false});
  final bool fromNav;

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    if (UserBloc.instance.isLogin) {
      sl<ProfileBloc>().add(Get());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromNav
          ? null
          : CustomAppBar(
              title: getTranslated("profile"),
            ),
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: Divider(
                        height: 32.h,
                        color: Styles.HINT_COLOR,
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        child: Divider(height: 32.h, color: Styles.HINT_COLOR)),
                  ],
                ),
              ))
            ],
          );
        },
      ),
    );
  }
}
