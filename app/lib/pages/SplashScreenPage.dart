import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    navigateToNextPageWithDelay();
  }

  void navigateToNextPageWithDelay() {
    Future.delayed(const Duration(seconds: 4), () {
      navigateToNextPage();
    });
  }

  void navigateToNextPage() {
    Navigator.pushReplacementNamed(context, '/sliderStart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
