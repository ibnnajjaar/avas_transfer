class ProfileModel {
  bool success;
  int code;
  String message;
  Payload payload;

  ProfileModel({this.success, this.code, this.message, this.payload});

  ProfileModel.fromJson(dynamic json) {
    success = json["success"];
    code = json["code"];
    message = json["message"];
    payload =
        json["payload"] != null ? Payload.fromJson(json["payload"]) : null;
  }
}

class Payload {
  UserInfo userInfo;
  List<Profile> profile;

  Payload({
    this.userInfo,
    this.profile,
  });

  Payload.fromJson(dynamic json) {
    userInfo =
        json["userInfo"] != null ? UserInfo.fromJson(json["userInfo"]) : null;
    if (json["profile"] != null) {
      profile = [];
      json["profile"].forEach((v) {
        profile.add(Profile.fromJson(v));
      });
    }
  }
}

class Profile {
  String name;
  String type;
  String owner;
  String profileType;
  String profile;
  List<dynamic> channels;

  Profile(
      {this.name,
      this.type,
      this.owner,
      this.profileType,
      this.profile,
      this.channels});

  Profile.fromJson(dynamic json) {
    name = json["name"];
    type = json["type"];
    owner = json["owner"];
    profileType = json["profile_type"];
    profile = json["profile"];
  }
}

class UserInfo {
  User user;
  dynamic profile;

  UserInfo({this.user, this.profile});

  UserInfo.fromJson(dynamic json) {
    user = json["user"] != null ? User.fromJson(json["user"]) : null;
    profile = json["profile"];
  }
}

class User {
  String fullname;
  String guid;

  User({this.fullname, this.guid});

  User.fromJson(dynamic json) {
    fullname = json["fullname"];
    guid = json["guid"];
  }
}
