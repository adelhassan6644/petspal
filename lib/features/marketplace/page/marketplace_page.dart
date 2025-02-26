import 'package:flutter/material.dart';

import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../main_widgets/main_app_bar.dart';
import '../../brands/widgets/brands_section.dart';
import '../../categories/view/categories_section.dart';
import '../../vendors/widgets/vendors_section.dart';
import '../widgets/marketplace_search_filter.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const MainAppBar(),
        Expanded(
          child: ListAnimator(
            data: [
              ///Search Field
              MarketplaceSearchFilter(),
              CategoriesSection(title: getTranslated("categories")),
              VendorsSection(title: getTranslated("featured_shops")),
              BrandsSection(title: getTranslated("popular_brands")),
              const SizedBox(height: 24)
            ],
          ),
        )
      ],
    ));
  }
}
