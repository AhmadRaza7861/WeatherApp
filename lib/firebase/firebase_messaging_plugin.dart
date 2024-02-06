import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:weather_app/state/state.dart';

import 'LocalNotification/local_notification_plugin.dart';
import 'package:get/get.dart';
@pragma('vm:entry-point')
Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
}

void _handleOpenedMassage(RemoteMessage message)
{
  print("${message.data}");
}
void _onRenewToken(String token)
{
  print("TOKEN ::$token");
}
Future<void>setupInteractedMessage()async{
  RemoteMessage? initMes=await FirebaseMessaging.instance.getInitialMessage();
  if(initMes !=null)
  {
    _handleMessage(initMes);
  }
  FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMassage);
  FirebaseMessaging.onMessage.listen(_handleMessage);
  FirebaseMessaging.instance.onTokenRefresh.listen(_onRenewToken);
  final fcmToken=await FirebaseMessaging.instance.getToken();
  Get.put(MyStateController()).tokenKey=fcmToken!;
  print('Token $fcmToken');
}
void _handleMessage(RemoteMessage message)async
{
  //To show notification
  await showNotification(message);
}