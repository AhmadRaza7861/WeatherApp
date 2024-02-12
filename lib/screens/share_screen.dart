
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:weather_app/common/color_constants.dart';
import 'package:weather_app/common/toast.dart';
import 'package:weather_app/main.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;

import '../state/state.dart';
class ShareScreen extends StatefulWidget {
  ShareScreen({Key? key,this.imageData}) : super(key: key);
  static route(Uint8List? imageData)=>MaterialPageRoute(builder: (context)=>ShareScreen(imageData:imageData));
  Uint8List? imageData;


  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {

  String pictureDirectoryPath="/storage/emulated/0/Pictures";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: ColorConstants.colorBg1,
        appBar: AppBar(

          leading: IconButton(
            icon:Platform.isAndroid?Icon(Icons.arrow_back):Icon(Icons.arrow_back_ios),
            onPressed: ()
            {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: widget.imageData==null?Image.asset("assets/icons/p1.png",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ):
                  Image.memory(widget.imageData!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(onPressed: (){
                      final Map<String, dynamic> data = {
                        "to": Get.put(MyStateController()).tokenKey,
                        //"dYcK1JbATuG45pJuToRlyd:APA91bEZnBOWdELsOfy2URD2sBdL-NvpCh70b2q1_VqdIFHRyJj4bj4fQJI-dKlU1Xjg_yTUqLTM_iz-iAktddgipfwK1Hc_mZ-gPoR5DrBArRXF_h_gsabfsvPY4O6md7j84jO67xEO",
                        "notification": {
                          "body": "Test Notification Show",
                          "OrganizationId": "2",
                          "content_available": true,
                          "priority": "high",
                          "subtitle": "Elementary School",
                          "title": "hello"
                        },
                        "data": {
                          "priority": "high",
                          "sound": "app_sound.wav",
                          "content_available": true,
                          "bodyText": "Test Notification Show",
                          "organization": "Elementary school"
                        }
                      };
                      http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
                          headers: <String, String>{
                            'Content-Type':'application/json',
                            "Authorization":"key=AAAAZr9DUKw:APA91bGDjwmK_gJiFn5ASnM_qdGoIhjERaLN5JDYivdZj2XWQ0ilEwY1tksTX1ptLehMoSl255Z0F7Ja0_Wpl396LSC98UqNAvIKmRdFtUN90kS7eMc79ORyheTA5Fs7X3fZjluk8NAw"
                          },
                          body:jsonEncode(data)
                      );
                    }, child: Text("ShowNotification")),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                    child: ElevatedButton(onPressed: ()async{

                          final Directory tempDir = await getTemporaryDirectory();
                          String imagePath="${tempDir.path}${DateTime.now().millisecond}.png";
                          File(imagePath).writeAsBytes(widget.imageData!);

                          final result = await Share.shareXFiles([XFile('$imagePath')], text: 'Great picture');

                          if (result.status == ShareResultStatus.success) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "")),(route) => false,);
                            final Map<String, dynamic> data = {
                              "to": Get.put(MyStateController()).tokenKey,
                              //"dYcK1JbATuG45pJuToRlyd:APA91bEZnBOWdELsOfy2URD2sBdL-NvpCh70b2q1_VqdIFHRyJj4bj4fQJI-dKlU1Xjg_yTUqLTM_iz-iAktddgipfwK1Hc_mZ-gPoR5DrBArRXF_h_gsabfsvPY4O6md7j84jO67xEO",
                              "notification": {
                                "body": "Share Successfully",
                                "OrganizationId": "2",
                                "content_available": true,
                                "priority": "high",
                                "subtitle": "Elementary School",
                                "title": "hello"
                              },
                              "data": {
                                "priority": "high",
                                "sound": "app_sound.wav",
                                "content_available": true,
                                "bodyText": "Share Successfully",
                                "organization": "Elementary school"
                              }
                            };
                            http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
                                headers: <String, String>{
                                  'Content-Type':'application/json',
                                  "Authorization":"key=AAAAZr9DUKw:APA91bGDjwmK_gJiFn5ASnM_qdGoIhjERaLN5JDYivdZj2XWQ0ilEwY1tksTX1ptLehMoSl255Z0F7Ja0_Wpl396LSC98UqNAvIKmRdFtUN90kS7eMc79ORyheTA5Fs7X3fZjluk8NAw"
                                },
                                body:jsonEncode(data)
                            );
                            print('Thank you for sharing the picture!');
                          }

                    },child: Text("Share"),)
                )),
              ],
            ),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                  child: ElevatedButton(onPressed: (){
                    SaveData();
                  },child: Text("Save"),)
                )),
              ],
            )
          ],
        )
    );
  }

  void SaveData()async {
    if(Platform.isAndroid)
    {
      String imagesDirectoryPath = '$pictureDirectoryPath/WeatherApp/';
      Directory(imagesDirectoryPath).createSync(recursive: true);
      String imagePath="$imagesDirectoryPath${DateTime.now().millisecond}.png";
      File(imagePath).writeAsBytes(widget.imageData!);
      String?  loadMediaMessage = await MediaScanner.loadMedia(path: imagePath,);
      showToast(message:"Saved Successfully",toastGravity: ToastGravity.CENTER);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "")),(route) => false,);
    }
    else
    {
      final result = await ImageGallerySaver.saveImage(widget.imageData??Uint8List(0),);
      ShowSnackBar(text: 'Saved Successfully', context: context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "")),(route) => false,);
    }
  }
}

