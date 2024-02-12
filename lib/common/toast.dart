import 'package:flutter/material.dart';
 import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/common/color_constants.dart';
void showToast({required String message,ToastGravity toastGravity=ToastGravity.CENTER}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIosWeb: 1,
      backgroundColor: ColorConstants.screenBackGroundColor,
      textColor: Colors.white,
      fontSize: 16.0
  );
}


void ShowSnackBar({required String text,required BuildContext context})
{
  var snackBar = SnackBar(content:Text(text),);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
