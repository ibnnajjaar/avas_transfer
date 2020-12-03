class TransferReviewModel {
  bool success;
  int code;
  String message;
  dynamic payload;

  TransferReviewModel({this.success, this.code, this.message, this.payload});

  TransferReviewModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    payload = json["payload"];
  }
}
