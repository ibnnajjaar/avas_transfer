import 'package:avas_transfer/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'constants.dart';

void main() async {
  await GetStorage.init();

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
            //textScaleFactor: data.textScaleFactor.clamp(0.8, 1.0),
            textScaleFactor: 1.0,
          ),
          child: child,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: appColor,
        accentColor: appColor,
        splashColor: appColor.withOpacity(0.1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dividerTheme: DividerThemeData().copyWith(
          space: 30,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: appColor,
          selectionColor: appColor.withOpacity(0.25),
          selectionHandleColor: appColor,
        ),
        fixTextFieldOutlineLabel: true,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: appColor,
              width: 1.5,
            ),
          ),
        ),
      ),
      home: Splash(),
    );
  }
}
