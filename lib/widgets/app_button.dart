import 'package:flutter/material.dart';
import 'package:mohta_app/constants/color_constants.dart';
import 'package:mohta_app/features/utils/screen_utils/app_paddings.dart';
import 'package:mohta_app/styles/font_sizes.dart';
import 'package:mohta_app/styles/text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonColor,
    this.borderColor,
    required this.title,
    this.titleSize,
    this.titleColor,
    required this.onPressed,
    this.isLoading = false, // New parameter
    this.loadingIndicatorColor,
  });

  final double? buttonHeight;
  final double? buttonWidth;
  final Color? buttonColor;
  final String title;
  final double? titleSize;
  final Color? titleColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final bool isLoading; // New parameter to indicate loading state
  final Color? loadingIndicatorColor; // Optional color for the spinner

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight ?? 45,
      width: buttonWidth ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: AppPaddings.p2,
          backgroundColor: buttonColor ?? kColorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              color: borderColor ?? (buttonColor ?? kColorPrimary),
            ),
          ),
        ),
        onPressed:
            isLoading ? null : onPressed, // Disable the button when loading
        child: isLoading
            ? SizedBox(
                height: 20, // Spinner size
                width: 20,
                child: CircularProgressIndicator(
                  color:
                      loadingIndicatorColor ?? kColorWhite, // Default to white
                  strokeWidth: 2,
                ),
              )
            : Text(
                title,
                style: TextStyles.kMediumSofiaSansSemiCondensed(
                  fontSize: titleSize ?? FontSizes.k20FontSize,
                  color: titleColor ?? kColorWhite,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
