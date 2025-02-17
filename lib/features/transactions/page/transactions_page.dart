import 'package:petspal/app/core/extensions.dart';
import 'package:petspal/features/transactions/bloc/transactions_bloc.dart';
import 'package:petspal/features/transactions/model/transactions_model.dart';
import 'package:petspal/features/transactions/repo/transactions_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';
import '../widgets/transaction_card.dart';
import '../widgets/wallet_card.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("cash_back"),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => TransactionsBloc(repo: sl<TransactionsRepo>())
            ..customScroll(controller)
            ..add(Click(arguments: SearchEngine())),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL.w),
              const WalletCard(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                    vertical: Dimensions.paddingSizeMini.h),
                child: Text(
                  getTranslated("transactions"),
                  style: AppTextStyles.w600
                      .copyWith(fontSize: 16, color: Styles.HEADER),
                ),
              ),
              Expanded(
                child: BlocBuilder<TransactionsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        data: List.generate(
                          10,
                          (i) => Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeMini.h),
                            child: CustomShimmerContainer(
                              height: 100.h,
                              width: context.width,
                              radius: 12.w,
                            ),
                          ),
                        ),
                      );
                    }
                    if (state is Done) {
                      List<TransactionModel> list =
                          state.list as List<TransactionModel>;
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<TransactionsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                controller: controller,
                                customPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                data: List.generate(
                                  list.length,
                                  (i) => TransactionCard(
                                    transaction: list[i],
                                  ),
                                ),
                              ),
                            ),
                            CustomLoadingText(loading: state.loading),
                          ],
                        ),
                      );
                    }
                    if (state is Empty || State is Error) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<TransactionsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                data: [
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  EmptyState(
                                    img: Images.emptyTransactions,
                                    imgHeight: 220.h,
                                    imgWidth: 220.w,
                                    txt: state is Error
                                        ? getTranslated("something_went_wrong")
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
