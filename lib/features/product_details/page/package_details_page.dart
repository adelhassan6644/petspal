import 'package:petspal/app/core/dimensions.dart';
import 'package:petspal/app/localization/language_constant.dart';
import 'package:petspal/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/core/app_event.dart';
import '../../../data/config/di.dart';
import '../bloc/product_details_bloc.dart';
import '../repo/product_details_repo.dart';
import '../widgets/product_details_action.dart';
import '../widgets/product_details_body.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("package_details"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              ProductDetailsBloc(repo: sl<ProductDetailsRepo>())
                ..add(Click(arguments: id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductDetailsBody(id: id),
              const PackageDetailsAction(),
            ],
          ),
        ),
      ),
    );
  }
}
