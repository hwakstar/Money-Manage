import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager/constants/app_theme.dart';
import 'package:money_manager/screens/settings/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home_drawer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final colorizeColors = [
    Colors.black,
    Colors.black,
    Colors.blue,
    AppTheme.appbarColor,
    Colors.transparent
  ];
  @override
  void initState() {
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);*/
    checkInited(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
          ),
          Image.asset('assets/images/spl_top.png'),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/images/spl_bottom.png'),
          ),
          Align(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(2, 5),
                        blurRadius: 10.0,
                        color: Color.fromARGB(100, 0, 0, 0),
                      )
                    ]),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/appicon.png'),
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('Money Manager',
                      textStyle: GoogleFonts.righteous(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            const Shadow(
                              offset: Offset(2, 5),
                              blurRadius: 10.0,
                              color: Color.fromARGB(100, 0, 0, 0),
                            ),
                          ]),
                      speed: const Duration(milliseconds: 600),
                      colors: colorizeColors),
                ],
                isRepeatingAnimation: false,
              ),
            ]),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    /*SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);*/
    super.dispose();
  }

  checkInited(context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isInited = prefs.getBool('isInited') ?? false;
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => isInited
                  ? const HomeDrawer()
                  : const EditProfile(
                      isFromInit: true,
                    )));
    });
  }
}
