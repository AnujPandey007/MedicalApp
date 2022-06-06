import 'package:doctor_client/screens/chatPage.dart';
import 'package:doctor_client/screens/signIn.dart';
import 'package:doctor_client/services/dataUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_client/mainPage.dart';
import 'package:doctor_client/screens/myAppointments.dart';
import 'package:doctor_client/screens/userProfile.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
          stream: DataUtils().authInstance,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return MainPage();
            } else {
              return SignIn();
            }}
      ),
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
    );
  }
}
