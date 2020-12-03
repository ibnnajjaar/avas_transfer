import 'dart:convert';

class DefaultModel {
  bool success;
  int code;
  String message;
  int payload;

  DefaultModel({this.success, this.code, this.message, this.payload});

  DefaultModel.fromJson(dynamic response) {
    var j = json.decode(response);
    success = j["success"];
    code = j["code"];
    message = j["message"];
    payload = j["payload"];
  }
}
