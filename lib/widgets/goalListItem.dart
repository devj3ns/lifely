import 'package:Lifely/data/goalModel.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../data/dataHelper.dart';
import '../navigatorHelper.dart';

class GoalListItem extends StatelessWidget {
  final Goal data;
  final bool isGoal;
  final Function confetti;

  GoalListItem(this.data, this.isGoal, this.confetti);

  @override
  Widget build(BuildContext context) {
    DataHelper provider = Provider.of<DataHelper>(context, listen: false);

    bool isAchieved = false;
    if (data.achieved && isGoal) {
      isAchieved = true;
    }

    return FrostedContainer(
      onTap: () {
        NavigatorHelper.openPopup(context, data, isGoal, provider, confetti);
      },
      borderRadius: 20,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        leading: Container(
          width: 40,
          child: FaIcon(
            data.icon,
            color: isAchieved ? Colors.white.withOpacity(0.6) : Colors.white,
            size: 35,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            data.title,
            style: TextStyle(
              color: isAchieved ? Colors.white.withOpacity(0.6) : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitle: Text(
          data.description,
          style: TextStyle(
            color: isAchieved ? Colors.white.withOpacity(0.6) : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
