import 'package:petspal/app/core/app_state.dart';
import 'package:petspal/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petspal/features/vendors/widgets/vendors_section.dart';
import '../../../app/core/app_event.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../best_seller/widgets/best_seller_section.dart';
import '../../categories/view/categories_section.dart';
import '../bloc/home_ads_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/main_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  void initState() {
    sl<HomeAdsBloc>().add(Click());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              const HomeAppBar(),
              Expanded(
                child: ListAnimator(
                  data: [
                    const MainServices(),
                    const CategoriesSection(),
                    const BestSellerSection(),
                    VendorsSection(title: getTranslated("vendors_offers")),
                    const SizedBox(height: 24)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
