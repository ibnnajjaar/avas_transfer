class DashboardModel {
  bool success;
  int code;
  String message;
  Payload payload;

  DashboardModel({
      this.success,
      this.code,
      this.message,
      this.payload});

  DashboardModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    payload = json["payload"] != null ? Payload.fromJson(json["payload"]) : null;
  }
}

class Payload {
  Config config;
  List<Dashboard> dashboard;

  Payload({
      this.config,
      this.dashboard});

  Payload.fromJson(dynamic json) {
    config = json["config"] != null ? Config.fromJson(json["config"]) : null;
    if (json["dashboard"] != null) {
      dashboard = [];
      json["dashboard"].forEach((v) {
        dashboard.add(Dashboard.fromJson(v));
      });
    }
  }
}

class Dashboard {
  String customer;
  String accountType;
  String product;
  String productCode;
  String currency;
  String productGroup;
  String primarySupplementary;
  dynamic secondaryCustomer;
  String statecode;
  String statuscode;
  String accountStatus;
  Actions actions;
  String id;
  String account;
  String alias;
  String contactType;
  dynamic workingBalance;
  dynamic ledgerBalance;
  dynamic clearedBalance;
  dynamic availableBalance;
  dynamic lockedAmount;
  String minimumBalance;
  dynamic overdraftLimit;
  dynamic availableLimit;
  dynamic creditLimit;
  String branch;
  bool success;

  Dashboard({
      this.customer,
      this.accountType,
      this.product,
      this.productCode,
      this.currency,
      this.productGroup,
      this.primarySupplementary,
      this.secondaryCustomer,
      this.statecode,
      this.statuscode,
      this.accountStatus,
      this.actions,
      this.id,
      this.account,
      this.alias,
      this.contactType,
      this.workingBalance,
      this.ledgerBalance,
      this.clearedBalance,
      this.availableBalance,
      this.lockedAmount,
      this.minimumBalance,
      this.overdraftLimit,
      this.availableLimit,
      this.creditLimit,
      this.branch,
      this.success});

  Dashboard.fromJson(dynamic json) {
    customer = json["customer"];
    accountType = json["account_type"];
    product = json["product"];
    productCode = json["product_code"];
    currency = json["currency"];
    productGroup = json["product_group"];
    primarySupplementary = json["primary_supplementary"];
    secondaryCustomer = json["secondary_customer"];
    statecode = json["statecode"];
    statuscode = json["statuscode"];
    accountStatus = json["account_status"];
    actions = json["actions"] != null ? Actions.fromJson(json["actions"]) : null;
    id = json["id"];
    account = json["account"];
    alias = json["alias"];
    contactType = json["contact_type"];
    workingBalance = json["workingBalance"];
    ledgerBalance = json["ledgerBalance"];
    clearedBalance = json["clearedBalance"];
    availableBalance = json["availableBalance"];
    lockedAmount = json["lockedAmount"];
    minimumBalance = json["minimumBalance"];
    overdraftLimit = json["overdraftLimit"];
    availableLimit = json["availableLimit"];
    creditLimit = json["creditLimit"];
    branch = json["branch"];
    success = json["success"];
  }

}

class Actions {
  bool transfer;
  bool history;
  bool pay;
  bool topup;

  Actions({
      this.transfer,
      this.history,
      this.pay,
      this.topup});

  Actions.fromJson(dynamic json) {
    transfer = json["transfer"];
    history = json["history"];
    pay = json["pay"];
    topup = json["topup"];
  }
}

class Config {
  int cardStatementMaxMonths;
  int casaHistoryMaxMonths;

  Config({
      this.cardStatementMaxMonths,
      this.casaHistoryMaxMonths});

  Config.fromJson(dynamic json) {
    cardStatementMaxMonths = json["card_statement_max_months"];
    casaHistoryMaxMonths = json["casa_history_max_months"];
  }
}