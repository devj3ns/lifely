import 'package:Lifely/data/dataHelper.dart';
import 'package:Lifely/data/goalModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';

class DashboardBox extends StatelessWidget {
  final Function openGoal;

  DashboardBox({this.openGoal});

  @override
  Widget build(BuildContext context) {
    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: true);

    Goal nextGoal = dataHelper.getNextGoal();
    bool hastNextGoal = nextGoal != null;

    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Quote(),
          );
        } else if (index == 1) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stats(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: NextGoal(
            goal: nextGoal,
            openGoal: openGoal,
          ),
        );
      },
      itemCount: hastNextGoal ? 3 : 2,
      pagination: new SwiperPagination(
        builder: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          int i = config.activeIndex;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 7,
                  width: 7,
                  color: i == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 7,
                  width: 7,
                  color: i == 1 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
              hastNextGoal
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(
                            height: 7,
                            width: 7,
                            color: i == 2
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
            ],
          );
        }),
        margin: EdgeInsets.only(bottom: 10),
      ),
    );
  }
}

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: true);
    AppLocalizations language = AppLocalizations.of(context);

    int achievedGoals = dataHelper.achievedGoals;
    int activeGoals = dataHelper.activeGoals;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  activeGoals.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  activeGoals == 1
                      ? language.translate("dashboard_box_activeGoalsSg")
                      : language.translate("dashboard_box_activeGoalsPl"),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*Icon(
                FontAwesomeIcons.rocket,
                size: 35,
                color: Colors.white,
              ),*/
              Image(
                height: 85,
                width: 85,
                image: AssetImage('assets/logotransparent.png'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  achievedGoals.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  achievedGoals == 1
                      ? language.translate("dashboard_box_achievedGoalsSg")
                      : language.translate("dashboard_box_achievedGoalsPl"),
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Text(
          AppLocalizations.of(context).translate("dashboard_boxText"),
          style: TextStyle(color: Colors.white, fontSize: 17.5),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

class NextGoal extends StatelessWidget {
  final Function openGoal;
  final Goal goal;

  NextGoal({this.goal, this.openGoal});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openGoal,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Text(
            AppLocalizations.of(context).translate("dashboard_box_nextGoal"),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "(" + DateFormat('dd.MM.yyyy').format(goal.date) + ")",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            leading: Container(
              width: 35,
              child: FaIcon(
                goal.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                goal.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
