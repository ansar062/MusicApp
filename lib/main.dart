import 'dart:async';

import 'package:flutter/material.dart';
import 'package:musik_task/Provider/audiofileprovider.dart';
import 'package:musik_task/Provider/dbnameprovider.dart';
import 'package:musik_task/Provider/filesInfoprovidder.dart';
import 'package:musik_task/Screens/DetailAudioPage.dart';
import 'package:musik_task/Screens/checking.dart';
import 'package:musik_task/Screens/loginScreen.dart';
import 'package:musik_task/Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AudioFileProvider()),
      ChangeNotifierProvider(create: (context) => AudioFileInfoProvider()),
      ChangeNotifierProvider(create: (context) => DBNameProvider()),
      Provider<FirebaseAuthMethods>(
        create: (context) => FirebaseAuthMethods(FirebaseAuth.instance),
      ),
      StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);
  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  MaterialColor primeColor = MaterialColor(0xFF337C36, color);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feel The Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => LogIn(),
      // }
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseUser = context.watch<User?>();

    if (FirebaseUser != null) {
      return DetailAudioPage();
    } else {
      return LogIn();
    }
  }
}
