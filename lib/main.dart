import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
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
               // 다양한 스마트폰 기기에서 어플을 확인할 수 있도록 DevicePreview Package를 사용한다.
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => MyApp(),
          )
        ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          // Splash 화면을 보여주기 위해....
          home: Ssplash(), 
        );
  }
}
