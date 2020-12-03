import 'package:avas_transfer/components/circular_indicator.dart';
import 'package:avas_transfer/components/message_dialog.dart';
import 'package:avas_transfer/screens/login_screen.dart';
import 'package:avas_transfer/screens/transfer_screen.dart';
import 'package:avas_transfer/services/api.dart' as api;
import 'package:avas_transfer/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _init(context) async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

    if (await Permission.sms.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

    await SharedPreferences.init();

    if (SharedPreferences.getString('username').isNotEmpty) {
      bool loggedIn = await api.login(context);
      if (loggedIn) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (BuildContext context) {
              return TransferScreen();
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => MessageDialog('Oops... Something went wrong.'),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) {
            return LoginScreen();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff900A22),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 85,
              child: Image.asset('assets/app_logo_white.png'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'AVAS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'TRANSFER',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                letterSpacing: 1.5,
                color: Colors.white30,
              ),
            ),
            SizedBox(
              height: 45,
            ),
            CircularIndicator(
              size: 25,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
