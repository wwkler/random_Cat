import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_cat_practice/home_screen.dart';
import 'package:random_cat_practice/sspplash.dart';
import 'package:random_cat_practice/stroage/stroage.dart';

void main() {
  runApp(
    // 중앙 집중식 관리 데이터를 쓰기 위해 Provider Setting을 한다.
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UseProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // Splash 화면을 보여주기 위해....
          home: Ssplash(), 
        )),
  );
}
