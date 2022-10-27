// ignore_for_file: file_names
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    // we restore all this widget when the page is loaded
    _loadLang();
  }

  var sysLng = Platform.localeName.split('_')[0];

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sysLng = (prefs.getString('lang') ?? Platform.localeName.split('_')[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('pictures/contact_up.png'),
      logoWidth: 120,
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: Text(sysLng == "fr" ? "Chargement..." : "Loading..."),
      navigator: "/home",
      durationInSeconds: 3,
    );
  }
}
