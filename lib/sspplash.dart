import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_cat_practice/home_screen.dart';

class Ssplash extends StatefulWidget {
  Ssplash({Key? key}) : super(key: key);

  @override
  State<Ssplash> createState() => _SsplashState();
}

class _SsplashState extends State<Ssplash> {
  @override
  void initState() {
    super.initState();

    // 8초간 Splash 화면을 보여준다.
    Timer(
        Duration(seconds: 8),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  // 본격적으로 Splash 화면을 꾸미는 부분
  // 딱 아다리 맞게, 3번만 Text 띄우고, 타이머 8초하니까 매우 자연스럽게 흘러간다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFed9e61),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Find',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
              const SizedBox(width: 20.0),
              DefaultTextStyle(
                style: GoogleFonts.bahiana(
                  fontSize: 70.0,
                  fontWeight: FontWeight.bold,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText('Cute Cat'),
                    RotateAnimatedText('Angry Cat'),
                    RotateAnimatedText('Good Cat'),
                  ],
                  totalRepeatCount: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
