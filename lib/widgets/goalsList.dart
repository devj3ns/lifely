import 'package:Lifely/data/goalModel.dart';
import 'package:Lifely/data/userModel.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../app_localizations.dart';
import '../data/dataHelper.dart';
import '../navigatorHelper.dart';
import 'frostedContainer.dart';
import 'goalListItem.dart';

class GoalsList extends StatefulWidget {
  final double padding;
  final Function confetti;

  GoalsList({this.padding, this.confetti});

  @override
  _GoalsListState createState() => _GoalsListState();
}

class _GoalsListState extends State<GoalsList> {
  @override
  Widget build(BuildContext context) {
    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: false);

    bool showAchievedGoals = dataHelper.user.showAchievedGoals;
    List<Goal> goals = Provider.of<DataHelper>(context, listen: true).goals;
    AppLocalizations language = AppLocalizations.of(context);

    bool achievedGoalsSeparatorCreated = false;

    bool showAchievedGoalsSeparatorCreated() {
      if (achievedGoalsSeparatorCreated == false) {
        achievedGoalsSeparatorCreated = true;
        return true;
      }
      return false;
    }

    void changeShowAchievedGoalsInDB(bool bool) {
      User _user = new User(
        showAchievedGoals: bool,
        name: dataHelper.user.name,
        firstLoginTime: dataHelper.user.firstLoginTime,
        bigFiveUnlocked: dataHelper.user.bigFiveUnlocked,
      );
      dataHelper.updateUser(_user);
      print(_user.showAchievedGoals);
    }

    return Stack(
      children: <Widget>[
        ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: widget.padding),
            itemCount: (goals.length + 1),
            itemBuilder: (BuildContext ctx, int index) {
              if (goals.length == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AddGoalsInfo(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: AddGoalButton(
                        confetti: widget.confetti,
                      ),
                    ),
                  ],
                );
              } else if (index < goals.length) {
                //########wenn Ziele vorhanden:
                return Column(
                  children: <Widget>[
                    goals[index].achieved && showAchievedGoalsSeparatorCreated()
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FrostedContainer(
                                onTap: () => setState(() {
                                  changeShowAchievedGoalsInDB(
                                      !showAchievedGoals);
                                  showAchievedGoals = !showAchievedGoals;
                                }),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      FaIcon(
                                        !showAchievedGoals
                                            ? FontAwesomeIcons.chevronDown
                                            : FontAwesomeIcons.chevronUp,
                                        color: Colors.white.withOpacity(0.9),
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        language.translate(
                                            "goalsList_achieved_goals"),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                borderRadius: 10,
                                color: Colors.blueGrey,
                              ),
                            ],
                          )
                        : SizedBox(),
                    (goals[index].achieved && showAchievedGoals) ||
                            goals[index].achieved == false
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: new GoalListItem(
                                goals[index], true, widget.confetti),
                          )
                        : SizedBox(),
                  ],
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AddGoalButton(),
                );
              }
            }),
      ],
    );
  }
}

class AddGoalsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          FaIcon(
            FontAwesomeIcons.pen,
            color: Colors.white,
            size: 45,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context).translate("big5AndGoal_start"),
            style: TextStyle(color: Colors.white, fontSize: 22),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class AddGoalButton extends StatelessWidget {
  final Function confetti;

  AddGoalButton({this.confetti});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: FrostedContainer(
        color: Colors.indigoAccent,
        onTap: () {
          NavigatorHelper.openPopup(
            context,
            new Goal(
              id: null,
            ),
            true,
            Provider.of<DataHelper>(context, listen: false),
            confetti,
          );
        },
        borderRadius: 15,
        child: Center(
          child: FaIcon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
