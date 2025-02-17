import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:zurex/app/core/dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zurex/features/splash/repo/splash_repo.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/animated_widget.dart';
import '../../../data/config/di.dart';
import '../bloc/splash_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with WidgetsBindingObserver {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // FlutterNativeSplash.remove();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc(repo: sl<SplashRepo>())..add(Click()),
      child: BlocBuilder<SplashBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
              body: Container(
            width: context.width,
            height: context.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      Images.splash,
                    ),
                    fit: BoxFit.cover)),
          ));
        },
      ),
    );
  }
}
