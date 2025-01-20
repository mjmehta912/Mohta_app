import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';
import 'package:mohta_app/widgets/app_appbar.dart';
import 'package:mohta_app/widgets/app_text_button.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
    required this.items,
    required this.prCode,
  });

  final List<Map<String, dynamic>> items;
  final String prCode;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final Map<int, bool> _expandedStates = {};

  @override
  Widget build(BuildContext context) {
    final Set<String> excludedKeys = {
      "ICODE",
      "BCODE",
      "MCODE",
      "IGCODE",
    };

    return Scaffold(
      backgroundColor: kColorWhite,
      appBar: AppAppbar(
        title: 'Items',
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
      body: Padding(
        padding: AppPaddings.p10,
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final filteredEntries = item.entries
                .where(
                  (entry) => !excludedKeys.contains(entry.key),
                )
                .toList();

            final previewEntries = filteredEntries.take(4).toList();
            final hiddenEntries = filteredEntries.skip(4).toList();

            return Card(
              elevation: 5,
              color: kColorLightGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: kColorTextPrimary,
                ),
              ),
              child: ExpansionTile(
                tilePadding: AppPaddings.ph10,
                childrenPadding: AppPaddings.custom(
                  bottom: 10,
                  left: 10,
                  right: 10,
                ),
                onExpansionChanged: (isExpanded) {
                  setState(
                    () {
                      _expandedStates[index] = isExpanded;
                    },
                  );
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...previewEntries.map(
                      (entry) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyles.kBoldSofiaSansSemiCondensed(
                                fontSize: FontSizes.k16FontSize,
                              ).copyWith(height: 1.25),
                            ),
                            Flexible(
                              child: Text(
                                '${entry.value ?? 'N/A'}',
                                style:
                                    TextStyles.kRegularSofiaSansSemiCondensed(
                                  fontSize: FontSizes.k16FontSize,
                                ).copyWith(
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if (!(_expandedStates[index] ?? false))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextButton(
                            onPressed: () {},
                            title: 'View \nPrice',
                          ),
                          AppTextButton(
                            onPressed: () {},
                            title: 'Comany \nStock',
                          ),
                          AppTextButton(
                            onPressed: () {},
                            title: 'Total \nStock',
                          ),
                        ],
                      ),
                  ],
                ),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...hiddenEntries.map(
                        (entry) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key}: ',
                                style: TextStyles.kBoldSofiaSansSemiCondensed(
                                  fontSize: FontSizes.k16FontSize,
                                ).copyWith(height: 1.25),
                              ),
                              Flexible(
                                child: Text(
                                  '${entry.value ?? 'N/A'}',
                                  style:
                                      TextStyles.kRegularSofiaSansSemiCondensed(
                                    fontSize: FontSizes.k16FontSize,
                                  ).copyWith(height: 1.25),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextButton(
                            onPressed: () {},
                            title: 'View \nPrice',
                          ),
                          AppTextButton(
                            onPressed: () {},
                            title: 'Comany \nStock',
                          ),
                          AppTextButton(
                            onPressed: () {},
                            title: 'Total \nStock',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
