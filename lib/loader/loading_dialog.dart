import 'package:flutter/material.dart';
import 'package:weather_app/common/color_constants.dart';

class LoadingDialogWidget extends StatefulWidget {
  const LoadingDialogWidget({Key? key}) : super(key: key);

  @override
  State<LoadingDialogWidget> createState() => _LoadingDialogWidgetState();
}

class _LoadingDialogWidgetState extends State<LoadingDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 120,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorConstants.colorBg2),
                  ),
                  SizedBox(height: 13),
                  Text(
                    "Loading...",
                    style: TextStyle(
                      color: ColorConstants.colorBg2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
