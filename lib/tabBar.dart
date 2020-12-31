import 'package:Lifely/screens/big5AndGoal.dart';
import 'package:Lifely/screens/dashboard.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

import 'app_localizations.dart';
import 'data/dataHelper.dart';

class MyTabBar extends StatelessWidget {
  final CupertinoTabController _tabController =
      CupertinoTabController(initialIndex: 1);

  @override
  Widget build(BuildContext context) {
    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: true);

    bool showGoalBadge = dataHelper.goals.length == 0;

    bool showBigFiveBadge;

    if (dataHelper.user.bigFiveUnlocked == null) {
      showBigFiveBadge = true;
    } else {
      showBigFiveBadge = !dataHelper.user.bigFiveUnlocked;
    }

    if (!dataHelper.durationUntilBigFiveUnlocked().isNegative) {
      showBigFiveBadge = false;
    }

    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
      child: CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Stack(children: <Widget>[
                Icon(
                  Icons.looks_5,
                  color: Colors.grey.withOpacity(0.2),
                ),
                showBigFiveBadge
                    ? Positioned(
                        // badge
                        top: 0.0,
                        right: 0.0,
                        child: Icon(
                          Icons.brightness_1,
                          size: 10.0,
                          color: Colors.redAccent,
                        ),
                      )
                    : SizedBox(),
              ]),
              activeIcon: RadiantGradientMask(
                child: Icon(
                  Icons.looks_5,
                  color: Colors.white,
                  size: 35,
                ),
                secondColor: Color(0xffFE2A72),
                firstColor: Color(0xff382350),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.grey.withOpacity(0.2),
              ),
              activeIcon: RadiantGradientMask(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 35,
                ),
                secondColor: Colors.lightBlueAccent,
                firstColor: Color(0xffc7dcaf),
              ),
            ),
            BottomNavigationBarItem(
              icon: Stack(children: <Widget>[
                FaIcon(
                  FontAwesomeIcons.bullseye,
                  size: 25,
                  color: Colors.grey.withOpacity(0.2),
                ),
                showGoalBadge
                    ? Positioned(
                        // badge
                        top: -0.5,
                        right: -0.5,
                        child: Icon(
                          Icons.brightness_1,
                          size: 10.0,
                          color: Colors.redAccent.withOpacity(0.9),
                        ),
                      )
                    : SizedBox(),
              ]),
              activeIcon: RadiantGradientMask(
                child: FaIcon(
                  FontAwesomeIcons.bullseye,
                  size: 28,
                  color: Colors.white,
                ),
                secondColor: Colors.indigoAccent,
                firstColor: Color(0xff382350),
              ),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return Big5AndGoal(
                goals: false,
                title: AppLocalizations.of(context)
                    .translate("big5AndGoal_mybig5"),
                subtitle: AppLocalizations.of(context)
                    .translate("big5AndGoal_big5text"),
                secondColor: Color(0xffFE2A72),
              );
              break;
            case 1:
              return Dashboard(tabController: _tabController);
              break;
            case 2:
              return Big5AndGoal(
                goals: true,
                title: AppLocalizations.of(context)
                    .translate("big5AndGoal_mygoals"),
                subtitle: AppLocalizations.of(context)
                    .translate("big5AndGoal_goalstext"),
                secondColor: Colors.indigoAccent,
              );
              break;
            default:
              return Dashboard();
              break;
          }
        },
      ),
    );
  }
}

class RadiantGradientMask extends StatelessWidget {
  RadiantGradientMask({this.child, this.secondColor, this.firstColor});
  final Widget child;
  final Color secondColor;
  final Color firstColor;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return ui.Gradient.linear(
          Offset(0, 24.0),
          Offset(24.0, 0),
          [
            secondColor,
            firstColor,
          ],
        );
      },
      child: child,
    );
  }
}
