import 'package:get/get.dart';
import 'package:mohta_app/features/item_details/models/godown_stock_dm.dart';

import 'package:mohta_app/features/item_details/models/item_details_dm.dart';
import 'package:mohta_app/features/item_details/models/item_stock_dm.dart';
import 'package:mohta_app/features/item_details/repositories/item_details_repo.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class ItemDetailsController extends GetxController {
  var isLoading = false.obs;
  var priceList = <PriceDm>[].obs;
  var companyStockList = <CompanyStockDm>[].obs;
  var godownStockList = <GodownStockDm>[].obs;
  var itemStockList = <ItemStockDm>[].obs;

  Future<void> getItemDetail({
    required String prCode,
    required String iCode,
    required String pCode,
  }) async {
    try {
      isLoading.value = true;
      final fetchedItemDetail = await ItemDetailsRepo.getItemDetail(
        prCode: prCode,
        iCode: iCode,
        pCode: pCode,
      );
      priceList.assignAll(fetchedItemDetail.priceDmData);
      companyStockList.assignAll(fetchedItemDetail.companyStockData);
    } catch (e) {
      if (e is Map<String, dynamic>) {
        showErrorSnackbar(
          'Error',
          e['message'],
        );
      } else {
        showErrorSnackbar(
          'Error',
          e.toString(),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getGodownStock({
    required String iCode,
    required String coCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedGdStock = await ItemDetailsRepo.getGodownStock(
        iCode: iCode,
        coCode: coCode,
      );

      godownStockList.assignAll(fetchedGdStock);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getItemStock({
    required String iCode,
    required String coCode,
  }) async {
    try {
      isLoading.value = true;

      final fetchedItemStock = await ItemDetailsRepo.getItemStock(
        iCode: iCode,
        coCode: coCode,
      );

      itemStockList.assignAll(fetchedItemStock);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
