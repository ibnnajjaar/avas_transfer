class TransferConfirmModel {
  bool success;
  int code;
  String message;
  Payload payload;

  TransferConfirmModel({this.success, this.code, this.message, this.payload});

  TransferConfirmModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    payload = json["payload"] != null ? Payload.fromJson(json["payload"]) : null;
  }
}

class Payload {
  String reference;
  String timestamp;
  String remarks;
  String messageType;
  From from;
  String id;
  To to;
  String currency;
  dynamic debitamount;

  Payload(
      {this.reference,
      this.timestamp,
      this.remarks,
      this.messageType,
      this.from,
      this.id,
      this.to,
      this.currency,
      this.debitamount});

  Payload.fromJson(dynamic json) {
    reference = json["reference"];
    timestamp = json["timestamp"];
    remarks = json["remarks"];
    messageType = json["messageType"];
    from = json["from"] != null ? From.fromJson(json["from"]) : null;
    id = json["id"];
    to = json["to"] != null ? To.fromJson(json["to"]) : null;
    currency = json["currency"];
    debitamount = json["debitamount"];
  }
}

class To {
  String name;
  String account;
  String contactType;

  To({this.name, this.account, this.contactType});

  To.fromJson(dynamic json) {
    name = json["name"];
    account = json["account"];
    contactType = json["contact_type"];
  }
}

class From {
  String account;
  String name;

  From({this.account, this.name});

  From.fromJson(dynamic json) {
    account = json["account"];
    name = json["name"];
  }
}
