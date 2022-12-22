import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cryptmark/pages/home_page.dart';
import 'package:cryptmark/pages/onboard_screen_page.dart';
import 'package:cryptmark/theme/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  final ThemeModel themeNotifier;
  const Splash({Key? key, required this.themeNotifier}) : super(key: key);
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(
                themeNotifier: widget.themeNotifier,
              )));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OnBoardScreen(
                themeNotifier: widget.themeNotifier,
              )));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
