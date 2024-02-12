import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/common/color_constants.dart';
import 'package:weather_app/screens/Weather_screen/weather_screen.dart';
import 'firebase/LocalNotification/local_notification_plugin.dart';
import 'firebase/firebase_messaging_plugin.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

 await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initLocalNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(statusBarColor: ColorConstants.colorBg1));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await setupInteractedMessage();
    });
    isAndroidPermissionGranted();
    requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return WeatherScreen(title: "WeatherScreen");
  }
}




