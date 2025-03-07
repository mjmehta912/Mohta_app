import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mohta_app/features/authentication/login/screens/login_screen.dart';
import 'package:mohta_app/features/authentication/register/repositories/register_repo.dart';
import 'package:mohta_app/features/utils/dialogs/app_dialogs.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  final registerFormKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var obscuredNewPassword = true.obs;
  void toggleNewPasswordVisibility() {
    obscuredNewPassword.value = !obscuredNewPassword.value;
  }

  var obscuredConfirmPassword = true.obs;
  void toggleConfirmPasswordVisibility() {
    obscuredConfirmPassword.value = !obscuredConfirmPassword.value;
  }

  var hasAttemptedSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    firstNameController.addListener(validateForm);
    lastNameController.addListener(validateForm);
    mobileNumberController.addListener(validateForm);
    passwordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedSubmit.value) {
      registerFormKey.currentState?.validate();
    }
  }

  Future<void> registerUser() async {
    isLoading.value = true;

    try {
      var response = await RegisterRepo.registerUser(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNo: mobileNumberController.text,
        password: passwordController.text,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        Get.offAll(
          () => LoginScreen(),
        );
        showSuccessSnackbar(
          'Success',
          message,
        );
      }
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
}
