import 'dart:convert';

import 'package:avas_transfer/components/message_dialog.dart';
import 'package:avas_transfer/models/contacts_model.dart';
import 'package:avas_transfer/models/dashboard_model.dart';
import 'package:avas_transfer/models/default_model.dart';
import 'package:avas_transfer/models/profile_model.dart';
import 'package:avas_transfer/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

const String baseUrl = 'www.bankofmaldives.com.mv';
const String apiPath = '/internetbanking/api/';

final JsonEncoder _encoder = new JsonEncoder();

Map<String, String> headers = {"content-type": "text/json"};
Map<String, String> cookies = {};

void _updateCookie(http.Response response) {
  String allSetCookie = response.headers['set-cookie'];

  if (allSetCookie != null) {
    var setCookies = allSetCookie.split(',');

    for (var setCookie in setCookies) {
      var cookies = setCookie.split(';');

      for (var cookie in cookies) {
        _setCookie(cookie);
      }
    }

    headers['cookie'] = _generateCookieHeader();
  }
}

void _setCookie(String rawCookie) {
  if (rawCookie.length > 0) {
    var keyValue = rawCookie.split('=');
    if (keyValue.length == 2) {
      var key = keyValue[0].trim();
      var value = keyValue[1];
      // ignore keys that aren't cookies
      if (key == 'path' || key == 'expires') return;
      cookies[key] = value;
    }
  }
}

String _generateCookieHeader() {
  String cookie = "";
  for (var key in cookies.keys) {
    if (cookie.length > 0) cookie += ";";
    cookie += key + "=" + cookies[key];
  }
  return cookie;
}

Future<http.Response> get(context, String path) async {
  var res =
      await http.get(Uri.https(baseUrl, apiPath + path), headers: headers);
  if (res.statusCode == 401) {
    bool loggedIn = await login(context);
    if (loggedIn)
      res =
          await http.get(Uri.https(baseUrl, apiPath + path), headers: headers);
    else
      _gotoLoginScreen(context);
  }

  if (res.statusCode != 200)
    showDialog(
      context: context,
      builder: (_) => MessageDialog('Oops... Something went wrong.'),
    );

  _updateCookie(res);
  return res;
}

Future<http.Response> post(context, String path, {body, encoding}) async {
  var res = await http.post(Uri.https(baseUrl, apiPath + path),
      body: _encoder.convert(body), headers: headers, encoding: encoding);

  if (res.statusCode == 401) {
    bool loggedIn = await login(context);
    if (loggedIn)
      res = await http.post(Uri.https(baseUrl, apiPath + path),
          body: _encoder.convert(body), headers: headers, encoding: encoding);
    else
      _gotoLoginScreen(context);
  }

  if (res.statusCode != 200)
    showDialog(
      context: context,
      builder: (_) => MessageDialog('Oops... Something went wrong.'),
    );

  _updateCookie(res);
  return res;
}

Future<bool> login(context) async {
  final box = GetStorage();

  var res = await post(
    context,
    'login',
    body: {
      'username': box.read('username'),
      'password': box.read('password'),
    },
  );
  DefaultModel model = DefaultModel.fromJson(res.body);

  if (model.success) {
    // await get(context, 'profile');
    var r1 = await get(context, 'profile');

    var profileModel = ProfileModel.fromJson(json.decode(r1.body));

    if (profileModel.payload.profile.length > 1) {
      var r11 = await post(
        context,
        'profile',
        body: {
          'profile': profileModel.payload.profile
              .firstWhere((element) => element.name == 'Personal')
              .profile,
        },
      );
    }

    var r2 = await get(context, 'contacts');
    contactsModel = ContactsModel.fromJson(json.decode(r2.body));
    var r3 = await get(context, 'dashboard');
    dashboardModel = DashboardModel.fromJson(json.decode(r3.body));
  }
  return model.success;
}

_gotoLoginScreen(context) {
  Navigator.pushReplacement(
    context,
    CupertinoPageRoute(
      builder: (BuildContext context) {
        return LoginScreen();
      },
    ),
  );
}
