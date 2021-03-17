import 'dart:convert';

import 'package:avas_transfer/models/contacts_model.dart';
import 'package:avas_transfer/models/dashboard_model.dart';
import 'package:avas_transfer/models/default_model.dart';
import 'package:avas_transfer/screens/transfer_screen.dart';
import 'package:avas_transfer/services/api.dart' as api;
import 'package:avas_transfer/utils/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../global.dart';
import 'message_dialog.dart';

class LoginCard extends StatefulWidget {
  @override
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  TextEditingController _loginIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool verifying = false;

  _login() async {
    FocusScope.of(context).unfocus();

    if (verifying) return;

    setState(() {
      verifying = true;
    });

    var res = await api.post(
      context,
      'login',
      body: {
        'username': _loginIdController.text.trim(),
        'password': _passwordController.text.trim()
      },
    );
    DefaultModel model = DefaultModel.fromJson(res.body);
    if (model.success) {
      await SharedPreferences.setString('username', _loginIdController.text.trim());
      await SharedPreferences.setString('password', _passwordController.text.trim());

      var r1 = await api.get(context, 'profile');
      debugPrint(r1.body.toString());
      var r2 = await api.get(context, 'contacts');
      contactsModel = ContactsModel.fromJson(json.decode(r2.body));
      var r3 = await api.get(context, 'dashboard');
      dashboardModel = DashboardModel.fromJson(json.decode(r3.body));
      await SharedPreferences.setString('accountId', dashboardModel.payload.dashboard[0].id);
      setState(() {
        verifying = false;
      });

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) {
            return TransferScreen();
          },
        ),
      );
    } else {
      setState(() {
        verifying = false;
      });

      showDialog(
        context: context,
        builder: (_) => MessageDialog(model.message),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            width: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appColor,
            ),
            child: Icon(Icons.lock_open_sharp, color: Colors.white, size: 35),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Enter BML Login ID and Password to continue'),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                TextField(
                  controller: _loginIdController,
                  textAlign: TextAlign.center,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Login ID',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    counterText: '',
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordController,
                  textAlign: TextAlign.center,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    counterText: '',
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              highlightedBorderColor: Colors.green.shade500,
              highlightColor: Colors.transparent,
              splashColor:  Colors.green.shade500.withOpacity(0.1),
              borderSide: BorderSide(
                color: Colors.green.shade500,
                width: 1.5,
              ),
              onPressed: () {
                _login();
              },
              child: verifying
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade500),
                        strokeWidth: 2,
                      ),
                    )
                  : Text('LOGIN',
                      style: TextStyle(
                        color: Colors.green.shade500,
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
