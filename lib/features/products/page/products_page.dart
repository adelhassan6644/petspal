import 'package:petspal/components/custom_app_bar.dart';
import 'package:petspal/features/categories/model/categories_model.dart';
import 'package:petspal/features/products/widgets/products_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/localization/language_constant.dart';
import '../../../../../data/config/di.dart';
import '../../../../../main_models/search_engine.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../bloc/products_bloc.dart';
import '../repo/products_repo.dart';
import '../widgets/products_header.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, required this.category});
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("products"),
      ),
      body: BlocProvider(
        create: (context) => ProductsBloc(
            repo: sl<ProductsRepo>(),
            internetConnection: sl<InternetConnection>())
          ..updateSelectCategory(category.id)
          ..add(Click(arguments: SearchEngine())),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Products Header
            ProductsHeader(),

            ///Products Body
            ProductsBody()
          ],
        ),
      ),
    );
  }
}
