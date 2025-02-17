import 'package:zurex/app/core/app_state.dart';
import 'package:zurex/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../categories/view/categories_view.dart';
import '../bloc/home_ads_bloc.dart';
import '../widgets/ads_section.dart';
import '../widgets/home_app_bar.dart';
import '../../products/widgets/top_products_section.dart';

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
      body: SafeArea(
        child: BlocBuilder<UserBloc, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                const HomeAppBar(),
                Expanded(
                  child: ListAnimator(
                    data: [
                      const AdsSection(),
                      const CategoriesView(),
                      const SizedBox(height: 24)
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
