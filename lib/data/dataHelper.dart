import 'package:Lifely/data/goalsDAO.dart';
import 'package:Lifely/data/userDAO.dart';
import 'package:Lifely/data/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bigFiveDAO.dart';
import 'goalModel.dart';

// singleton class to manage the database
class DataHelper with ChangeNotifier {
  DataHelper();

  //######################################++++++++++++++++++++++++++DATEN:
  List<Goal> goals;
  List<Goal> bigFives;
  User user;

  //wird nicht gespeichert:
  int activeGoals;
  int achievedGoals;

  //######################################++++++++++++++++++++++++++Funktionen

  GoalsDao _goalsDao = new GoalsDao();
  BigFivesDao _bigFivesDao = new BigFivesDao();
  UserDao _userDao = new UserDao();

  loadData() async {
    goals = await _goalsDao.getAllGoals();
    bigFives = await _bigFivesDao.getAllBigFives();
    user = await _userDao.getUser();

    sortGoals();

    activeGoals = _getActiveGoals();
    achievedGoals = _getAchievedGoals();

    //namen zurückgeben für main
    return user.name;
  }

  //################## Goals:

  //sort
  void sortGoals() {
    //Liste nach Erreicht/nicht erreicht sortieren
    goals.sort((a, b) => toBool(a.achieved).compareTo(toBool(b.achieved)));

    List<Goal> achievedGoals = [];
    List<Goal> notAchievedGoals = [];

    goals.forEach((Goal goal) {
      if (goal.achieved) {
        achievedGoals.add(goal);
      } else {
        notAchievedGoals.add(goal);
      }
    });

    achievedGoals.sort((a, b) => getDateToCompare(a.achievedDate)
        .compareTo(getDateToCompare(b.achievedDate)));
    notAchievedGoals.sort(
        (a, b) => getDateToCompare(a.date).compareTo(getDateToCompare(b.date)));

    goals = notAchievedGoals + achievedGoals;
  }

  //insert
  Future insertGoal(Goal goal) async {
    goals.add(goal);

    sortGoals();

    notifyListeners();
    _goalsDao.updateOrInsert(goal);

    activeGoals = _getActiveGoals();
    achievedGoals = _getAchievedGoals();
  }

  Future insertBigFive(Goal goal) async {
    bigFives.add(goal);
    notifyListeners();
    _bigFivesDao.updateOrInsert(goal);
  }

  //update
  Future updateGoal(Goal goal) async {
    int i = goals.indexWhere((Goal _goal) => _goal.id == goal.id);
    goals[i] = goal;

    sortGoals();

    notifyListeners();
    _goalsDao.updateOrInsert(goal);

    activeGoals = _getActiveGoals();
    achievedGoals = _getAchievedGoals();
  }

  Future updateBigFive(Goal goal) async {
    int i = bigFives.indexWhere((Goal _goal) => _goal.id == goal.id);
    bigFives[i] = goal;
    notifyListeners();
    _bigFivesDao.updateOrInsert(goal);
  }

  //delete
  Future deleteGoal(Goal goal) async {
    goals.removeWhere((Goal _goal) => _goal.id == goal.id);
    notifyListeners();
    _goalsDao.delete(goal);

    activeGoals = _getActiveGoals();
    achievedGoals = _getAchievedGoals();
  }

  Future deleteBigFive(Goal goal) async {
    bigFives.removeWhere((Goal _goal) => _goal.id == goal.id);
    notifyListeners();
    _bigFivesDao.delete(goal);
  }

  loadBigFiveExampleData(bool isEng) {
    //wird von initState im Dashboard aufgerufen, wenn 0 big fives in liste
    print("loading big five example data...");

    if (!isEng) {
      exampleBigFivesDE.forEach((Goal bigFive) {
        bigFives.add(bigFive);
        _bigFivesDao.updateOrInsert(bigFive);
      });
    } else {
      exampleBigFivesENG.forEach((Goal bigFive) {
        bigFives.add(bigFive);
        _bigFivesDao.updateOrInsert(bigFive);
      });
    }
  }

  int _getAchievedGoals() {
    int amount = 0;
    goals.forEach((Goal goal) {
      if (goal.achieved == true) {
        amount++;
      }
    });
    return amount;
  }

  int _getActiveGoals() {
    int amount = 0;
    goals.forEach((Goal goal) {
      if (goal.achieved == false) {
        amount++;
      }
    });
    return amount;
  }

  //################## User:

  //insert
  Future insertUser(User _user) async {
    user = _user;
    notifyListeners();
    _userDao.updateOrInsert(_user);
  }

  //update
  Future updateUser(User _user) async {
    user = _user;
    notifyListeners();
    _userDao.updateOrInsert(_user);
  }

  //#### general:

  //clear
  clearDataAndDatabase() async {
    await _userDao.delete();
    await _goalsDao.deleteAll();
    await _bigFivesDao.deleteAll();

    goals = [];
    bigFives = [];
    user = null;
  }

  //################## others:

  Duration durationUntilBigFiveUnlocked() {
    DateTime unlockTime = user.firstLoginTime.add(Duration(days: 1));
    Duration duration = unlockTime.difference(DateTime.now());
    return duration;
  }

  int toBool(bool b) {
    return b == true ? 1 : 0;
  }

  DateTime getDateToCompare(DateTime date) {
    //wandelt Datum um, damit es nicht = null ist
    if (date == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
    return date;
  }

  Goal getNextGoal() {
    Goal goal;
    sortGoals();
    goal = goals.firstWhere(
        (Goal _goal) => _goal.date != null && _goal.achieved == false,
        orElse: () => null);

    return goal;
  }
}

//############################# Example Data

final List<Goal> exampleBigFivesDE = [
  Goal(
    id: 0,
    bigFive: true,
    achieved: false,
    icon: FontAwesomeIcons.user,
    title: "ZDE",
    description:
        "Alles erleben, was ich mir für mein Leben wünsche und das Leben meines gesamten Umfelds bereichern.",
  ),
  Goal(
    id: 1,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_one,
    title: "GROWTH",
    description:
        "Mich immer weiterentwickeln und die beste Version meiner Selbst sein.",
  ),
  Goal(
    id: 2,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_two,
    title: "FREEDOM",
    description:
        "Frei sein! Frei darin was ich arbeite, finanziell, wo ich wohne und wie ich meine Tag gestalte.",
  ),
  Goal(
    id: 3,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_3,
    title: "TRAVEL",
    description:
        "Die Welt bereisen, so viele Kulturen und Menschen wie möglich kennenlernen.",
  ),
  Goal(
    id: 4,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_4,
    title: "FAMILY & FRIENDS",
    description:
        "Tolles Familienmitglied und Freund sein. Eine wunderbare Familie gründen und meinen Kindern ein Vorbild sein.",
  ),
  Goal(
    id: 5,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_5,
    title: "ENJOY",
    description:
        "Mein Leben genießen und Spaß haben, tolle Momente mit wunderbaren Menschen erleben und Erfahrungen sammeln.",
  ),
];

final List<Goal> exampleBigFivesENG = [
  Goal(
    id: 0,
    bigFive: true,
    achieved: false,
    icon: FontAwesomeIcons.user,
    title: "PFE",
    description:
        "Experience everything I want for my life and enrich the life of people in my surrounding.",
  ),
  Goal(
    id: 1,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_one,
    title: "GROWTH",
    description: "Always evolve and be the best version of myself.",
  ),
  Goal(
    id: 2,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_two,
    title: "FREEDOM",
    description:
        "Be free! Free in what I work, financially, where I live and how I organize my day.",
  ),
  Goal(
    id: 3,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_3,
    title: "TRAVEL",
    description:
        "Travel the world, get to know as many cultures and people as possible.",
  ),
  Goal(
    id: 4,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_4,
    title: "FAMILY & FRIENDS",
    description:
        "Be a great family member and friend. Start a wonderful family and be a role model for my children.",
  ),
  Goal(
    id: 5,
    bigFive: true,
    achieved: false,
    icon: Icons.looks_5,
    title: "ENJOY",
    description:
        "Enjoy my life and have fun, experience great moments with wonderful people and gain experience.",
  ),
];
