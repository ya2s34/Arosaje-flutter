import 'package:app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'pages/SplashScreenPage.dart';
import 'pages/SliderStartPage.dart';
import 'pages/inscription.dart';
import 'pages/connexion.dart';
import 'pages/home.dart';
import 'pages/message.dart';
import 'pages/post.dart';
import 'pages/search.dart';

void main() async {
  // await dotenv.load(fileName: '/app/');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mon application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenPage(),
        '/sliderStart': (context) => SliderStartPage(),
        '/inscription': (context) => InscriptionPage(),
        '/connexion': (context) => ConnexionPage(),
        '/message': (context) => MessagePage(),
        '/post': (context) => PostPage(),
        '/search': (context) => SearchPage(),
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
