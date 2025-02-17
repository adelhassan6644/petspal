import 'package:zurex/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/app_event.dart';
import '../../../../data/config/di.dart';
import '../../../../main_widgets/text_of_agree_terms.dart';
import '../bloc/login_bloc.dart';
import '../repo/login_repo.dart';
import '../widgets/login_body.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(repo: sl<LoginRepo>())..add(Remember()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              LoginBody(),
              const TextOfAgreeTerms(fromWelcomeScreen: false),
            ],
          ),
        ),
      ),
    );
  }
}
