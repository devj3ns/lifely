import 'dart:convert';

import 'package:flutter/material.dart';

class ChecklistItem {
  bool done;
  String text;

  ChecklistItem({this.done, this.text});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      done: json["done"],
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() => {
        "done": done,
        "text": text,
      };
}

class Goal {
  int id;
  bool bigFive;
  bool achieved;
  DateTime achievedDate;
  IconData icon;
  String title;
  String description;
  String note;
  DateTime date;
  List<ChecklistItem> checklist;

  Goal({
    this.id,
    this.icon,
    this.bigFive,
    this.achieved,
    this.achievedDate,
    this.title,
    this.description,
    this.note,
    this.date,
    this.checklist,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    List<ChecklistItem> checklist = [];

    if (json["checklist"] != null) {
      json["checklist"].forEach((dynamic map) {
        checklist.add(ChecklistItem.fromJson(map));
      });
    }

    return Goal(
      id: json["id"],
      bigFive: json["bigFive"],
      achieved: json["achieved"] != null ? json["achieved"] : false,
      achievedDate: json["achievedDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["achievedDate"])
          : null,
      icon: iconDataFromJSONString(json["icon"]),
      title: json["title"],
      description: json["description"],
      note: json["note"],
      date: json["date"] != null
          ? DateTime.fromMillisecondsSinceEpoch(json["date"])
          : null,
      checklist: checklist,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "bigFive": bigFive,
        "achieved": achieved,
        "achievedDate":
            achievedDate != null ? achievedDate.millisecondsSinceEpoch : null,
        "icon": jsonStringFromIconData(icon),
        "title": title,
        "description": description,
        "note": note,
        "date": date != null ? date.millisecondsSinceEpoch : null,
        "checklist": checklist != null
            ? checklist
                .map((ChecklistItem checklistItem) => checklistItem.toJson())
            : null,
      };

  static String jsonStringFromIconData(IconData data) {
    Map<String, dynamic> map = <String, dynamic>{};
    map['codePoint'] = data.codePoint;
    map['fontFamily'] = data.fontFamily;
    map['fontPackage'] = data.fontPackage;
    map['matchTextDirection'] = data.matchTextDirection;
    return jsonEncode(map);
  }

  static IconData iconDataFromJSONString(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return IconData(
      map['codePoint'],
      fontFamily: map['fontFamily'],
      fontPackage: map['fontPackage'],
      matchTextDirection: map['matchTextDirection'],
    );
  }
}
