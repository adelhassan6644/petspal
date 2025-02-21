import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:petspal/app/core/dimensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/components/custom_images.dart';
import 'package:petspal/features/splash/repo/splash_repo.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/images.dart';
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
    FlutterNativeSplash.remove();
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
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
              ),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(Images.splash), fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    customImageIcon(
                      imageName: Images.logo,
                      height: 80.h,
                      width: context.width * 0.7,
                      fit: BoxFit.contain,
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                          duration: 1000.ms,
                          delay: 0.ms,
                          curve: Curves.easeInOut,
                        )
                        .then(delay: 200.ms)
                        .shimmer(duration: 1000.ms, curve: Curves.easeInOut),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
