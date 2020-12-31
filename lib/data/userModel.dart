

class User {
  String name;
  DateTime firstLoginTime;
  bool bigFiveUnlocked;
  bool showAchievedGoals;

  User({
    this.name,
   this.firstLoginTime,
    this.bigFiveUnlocked,
    this.showAchievedGoals,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return new User(name: "");
      //wichtig, dass es ein leerer String ist! wegen main
    }

    return User(
      name: json["name"],
      firstLoginTime:
          DateTime.fromMillisecondsSinceEpoch(json["firstLoginTime"]),
      bigFiveUnlocked:
          json["bigFiveUnlocked"] != null ? json["bigFiveUnlocked"] : false,
      showAchievedGoals:
          json["showAchievedGoals"] != null ? json["showAchievedGoals"] : true,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "firstLoginTime": firstLoginTime.millisecondsSinceEpoch,
        "bigFiveUnlocked": bigFiveUnlocked,
        "showAchievedGoals": showAchievedGoals,
      };
}
