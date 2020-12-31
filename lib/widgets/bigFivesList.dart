import 'package:Lifely/data/goalModel.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../data/dataHelper.dart';
import 'goalListItem.dart';

class BigFivesList extends StatelessWidget {
  final double padding;
  final Function confetti;

  BigFivesList({this.padding, this.confetti});

  @override
  Widget build(BuildContext context) {
    List<Goal> bigFives =
        Provider.of<DataHelper>(context, listen: true).bigFives;

    return Stack(
      children: <Widget>[
        ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: padding),
          itemCount: bigFives.length,
          itemBuilder: (BuildContext ctx, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: new GoalListItem(bigFives[index], false, confetti),
            );
          },
        ),
      ],
    );
  }
}
