import 'package:zurex/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/components/custom_app_bar.dart';
import '../../../../data/config/di.dart';
import '../bloc/register_bloc.dart';
import '../repo/register_repo.dart';
import '../widget/register_actions.dart';
import '../widget/register_body.dart';
import '../widget/register_header.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(repo: sl<RegisterRepo>()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocBuilder<RegisterBloc, AppState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterHeader(),
                  RegisterBody(),
                  RegisterActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
