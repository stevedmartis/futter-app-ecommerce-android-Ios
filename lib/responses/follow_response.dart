// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

FollowResponse followResponseFromJson(String str) =>
    FollowResponse.fromJson(json.decode(str));

String followResponseToJson(FollowResponse data) => json.encode(data.toJson());

class FollowResponse {
  FollowResponse({
    this.ok,
    this.follow,
  });

  bool ok;
  Follow follow;

  factory FollowResponse.fromJson(Map<String, dynamic> json) => FollowResponse(
        ok: json["ok"],
        follow: Follow.fromJson(json["follow"]),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "follow": follow.toJson(),
      };
}

class Follow {
  Follow({
    this.isFollowing,
    this.isStoreNotifi,
    this.isFollowerNotifi,
    this.follower,
    this.store,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  bool isFollowing;
  bool isStoreNotifi;
  bool isFollowerNotifi;
  String follower;
  String store;
  DateTime createdAt;
  DateTime updatedAt;
  String id;

  factory Follow.fromJson(Map<String, dynamic> json) => Follow(
        isFollowing: json["isFollowing"],
        isStoreNotifi: json["isStoreNotifi"],
        isFollowerNotifi: json["isFollowerNotifi"],
        follower: json["follower"],
        store: json["store"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "isFollowing": isFollowing,
        "isStoreNotifi": isStoreNotifi,
        "isFollowerNotifi": isFollowerNotifi,
        "follower": follower,
        "store": store,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
      };
}
