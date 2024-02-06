import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:screenshot/screenshot.dart';

import '../screens/crop_screen.dart';

class MyStateController extends GetxController
{
  var isEnableLocation=false.obs;
  var locationData=LocationData.fromMap(<String,dynamic>{}).obs;

  var isLoading=false.obs;

  var tokenKey="";

  final ScreenshotController screenshotController = ScreenshotController();

  void CaptureScreenShoot(BuildContext context)
  {
    screenshotController.capture().then((Uint8List? image) {
      // image is the bytes of the screenshot
      print("image $image");
      Navigator.push(
          context,
          CropScreen.route(image!)
      );
    }).catchError((onError) {
      print(onError);
    });
  }

}