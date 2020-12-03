class ContactsModel {
  bool success;
  int code;
  String message;
  List<Payload> payload;

  ContactsModel({this.success, this.code, this.message, this.payload});

  ContactsModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    if (json["payload"] != null) {
      payload = [];
      json["payload"].forEach((v) {
        payload.add(Payload.fromJson(v));
      });
    }
  }
}

class Payload {
  int id;
  String name;
  dynamic avatar;
  String favorite;
  String account;
  dynamic swift;
  dynamic correspondentSwift;
  dynamic address;
  dynamic city;
  dynamic state;
  dynamic postcode;
  dynamic country;
  String contactType;
  dynamic merchant;
  String createdAt;
  String updatedAt;
  dynamic deletedAt;
  dynamic bpayVendor;
  dynamic domesticBankCode;
  dynamic serviceNumber;
  dynamic mobileNumber;
  String alias;
  String status;
  String inputter;
  String owner;
  String currency;
  bool removable;
  dynamic vendor;

  Payload(
      {this.id,
      this.name,
      this.avatar,
      this.favorite,
      this.account,
      this.swift,
      this.correspondentSwift,
      this.address,
      this.city,
      this.state,
      this.postcode,
      this.country,
      this.contactType,
      this.merchant,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.bpayVendor,
      this.domesticBankCode,
      this.serviceNumber,
      this.mobileNumber,
      this.alias,
      this.status,
      this.inputter,
      this.owner,
      this.currency,
      this.removable,
      this.vendor});

  Payload.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    avatar = json["avatar"];
    favorite = json["favorite"];
    account = json["account"];
    swift = json["swift"];
    correspondentSwift = json["correspondent_swift"];
    address = json["address"];
    city = json["city"];
    state = json["state"];
    postcode = json["postcode"];
    country = json["country"];
    contactType = json["contact_type"];
    merchant = json["merchant"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    bpayVendor = json["bpay_vendor"];
    domesticBankCode = json["domestic_bank_code"];
    serviceNumber = json["service_number"];
    mobileNumber = json["mobile_number"];
    alias = json["alias"];
    status = json["status"];
    inputter = json["inputter"];
    owner = json["owner"];
    currency = json["currency"];
    removable = json["removable"];
    vendor = json["vendor"];
  }
}
