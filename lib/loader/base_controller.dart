import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading_dialog.dart';


class BaseController extends GetxController {
  static bool isLoaderShow = false;
  Rx<Error> error = Error().obs;

  void showLoader() {
    isLoaderShow = true;
    Get.dialog(
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: LoadingDialogWidget(),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> dismissLoader() async {
    if (Get.isSnackbarOpen) {
      await Future.delayed(const Duration(seconds: 1));
      dismissLoader();
      return;
    }
    if (isLoaderShow) {
      isLoaderShow = false;
      Get.back();
    }
  }

  void showError(
      {String title = "Alert!", String? msg, bool isDialogNotDismiss = false}) {
    if (!isDialogNotDismiss) {
      dismissLoader();
    }
    if (msg != null) {
      Get.snackbar(title, msg,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          colorText: Colors.white);
    }
  }

  void showSnack({String title = "Alert!", String? msg}) {
    dismissLoader();
    if (msg != null) {
      Get.snackbar(title, msg,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
    }
  }

  // void setError({required ErrorType errorType}) {
  //   error.value.errorType = errorType;
  //   error.refresh();
  // }

  void removeUnFocusManager() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

}
