import 'package:avas_transfer/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xff900A22),
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BML',
      builder: (BuildContext context, Widget child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: data.textScaleFactor.clamp(1.0, 1.2),
          ),
          child: child,
        );
      },
      theme: ThemeData(
        primaryColor: appColor,
        accentColor: appColor,
        splashColor: appColor.withOpacity(0.1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dividerTheme: DividerThemeData().copyWith(
          space: 30,
        ),
      ),
      home: Splash(),
    );
  }
}
