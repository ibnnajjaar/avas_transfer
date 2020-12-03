class AccountValidateModel {
  bool success;
  int code;
  String message;
  Payload payload;

  AccountValidateModel({
      this.success, 
      this.code, 
      this.message, 
      this.payload});

  AccountValidateModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    payload = json["payload"] != null ? Payload.fromJson(json["payload"]) : null;
  }
}

class Payload {
  String account;
  String name;
  dynamic alias;
  String currency;
  dynamic trnCurrency;
  String trnType;
  String accountType;
  dynamic productGroup;
  bool isContact;
  dynamic bmlCustomerproductId;
  dynamic cardnumber;

  Payload({
      this.account, 
      this.name, 
      this.alias, 
      this.currency, 
      this.trnCurrency, 
      this.trnType, 
      this.accountType, 
      this.productGroup, 
      this.isContact, 
      this.bmlCustomerproductId, 
      this.cardnumber});

  Payload.fromJson(dynamic json) {
    account = json["account"];
    name = json["name"];
    alias = json["alias"];
    currency = json["currency"];
    trnCurrency = json["trnCurrency"];
    trnType = json["trnType"];
    accountType = json["account_type"];
    productGroup = json["product_group"];
    isContact = json["isContact"];
    bmlCustomerproductId = json["bml_customerproductId"];
    cardnumber = json["cardnumber"];
  }
}