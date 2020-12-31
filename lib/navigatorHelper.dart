import 'package:Lifely/widgets/lifelyPopup.dart';
import 'package:Lifely/widgets/popup.dart';
import 'package:flutter/material.dart';

import 'data/dataHelper.dart';
import 'data/goalModel.dart';

class NavigatorHelper {
  static void openPopup(var context, Goal data, bool isGoal,
      DataHelper provider, Function confetti) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => Popup(
            data: data, isGoal: isGoal, provider: provider, confetti: confetti),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static void openLifelyPopup(var context, String text, String name) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => LifelyPopup(
          username: name,
          text: text,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
