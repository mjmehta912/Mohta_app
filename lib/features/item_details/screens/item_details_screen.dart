import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/item_details/controllers/item_details_controller.dart';
import 'package:mohta_app/features/item_details/widgets/item_detail_card_row.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_card.dart';
import 'package:mohta_app/widgets/app_loading_overlay.dart';

class ItemDetailsScreen extends StatefulWidget {
  final int selectedTabIndex;
  final String prCode;
  final String iCode;

  const ItemDetailsScreen({
    super.key,
    required this.selectedTabIndex,
    required this.prCode,
    required this.iCode,
  });

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final ItemDetailsController _controller = Get.put(
    ItemDetailsController(),
  );

  @override
  void initState() {
    super.initState();
    initialize();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.selectedTabIndex,
    );
  }

  void initialize() async {
    await _controller.getItemDetail(
      prCode: widget.prCode,
      iCode: widget.iCode,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorWhite,
          appBar: AppAppbar(
            title: 'Item Details',
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kColorTextPrimary,
                size: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelStyle: TextStyles.kSemiBoldSofiaSansSemiCondensed(
                  color: kColorPrimary,
                  fontSize: FontSizes.k16FontSize,
                ),
                unselectedLabelColor: kColorGrey,
                indicatorColor: kColorPrimary,
                tabs: const [
                  Tab(text: 'View Price'),
                  Tab(text: 'Company Stock'),
                  Tab(text: 'Total Stock'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildViewPrice(),
                    _buildCompanyStock(),
                    _buildTotalStock(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalStock() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.totalStockList.isEmpty &&
              !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No total stock found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.totalStockList.length,
            itemBuilder: (context, index) {
              final totalStock = _controller.totalStockList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemDetailCardRow(
                        title: 'Bill Date',
                        value: totalStock.billDate,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Qty',
                            value: totalStock.qty.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Rate',
                            value: totalStock.rate.toString(),
                          ),
                        ],
                      ),
                      ItemDetailCardRow(
                        title: 'Days',
                        value: totalStock.days.toString(),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCompanyStock() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.companyStockList.isEmpty &&
              !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No company stock found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.companyStockList.length,
            itemBuilder: (context, index) {
              final companyStock = _controller.companyStockList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Company',
                            value: companyStock.cmp,
                          ),
                          ItemDetailCardRow(
                            title: 'Total Stock',
                            value: companyStock.totalStk.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Damage',
                            value: companyStock.damage.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Resv Stock',
                            value: companyStock.resvStk.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Godown Stock',
                            value: companyStock.godownStk.isNotEmpty
                                ? companyStock.godownStk.toString()
                                : 'N/A',
                          ),
                          ItemDetailCardRow(
                            title: 'SO Qty',
                            value: companyStock.soQty.toString(),
                          ),
                        ],
                      ),
                      ItemDetailCardRow(
                        title: 'Card Stock',
                        value: companyStock.cardStk != null &&
                                companyStock.cardStk!.isNotEmpty
                            ? companyStock.cardStk!
                            : 'N/A',
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }

  Padding _buildViewPrice() {
    return Padding(
      padding: AppPaddings.p10,
      child: Obx(
        () {
          if (_controller.priceList.isEmpty && !_controller.isLoading.value) {
            return Center(
              child: Text(
                'No prices found.',
                style: TextStyles.kMediumSofiaSansSemiCondensed(),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.priceList.length,
            itemBuilder: (context, index) {
              final price = _controller.priceList[index];

              return AppCard(
                child: Padding(
                  padding: AppPaddings.p10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemDetailCardRow(
                        title: 'Price Head',
                        value: price.priceHead,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Prev. Price',
                            value: price.prvPrice.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Price',
                            value: price.price.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Max Disc %',
                            value: price.maxDiscP.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Max Disc Amt',
                            value: price.maxDiscA.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'Min SRate',
                            value: price.minSRate.toString(),
                          ),
                          ItemDetailCardRow(
                            title: 'Market Price',
                            value: price.marketPrice.toString(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ItemDetailCardRow(
                            title: 'I/W',
                            value: price.iw,
                          ),
                          ItemDetailCardRow(
                            title: 'O/W',
                            value: price.ow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
