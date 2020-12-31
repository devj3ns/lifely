import 'package:Lifely/navigatorHelper.dart';
import 'package:Lifely/screens/LetterScreen.dart';
import 'package:Lifely/screens/settings.dart';
import 'package:Lifely/widgets/dashboardBox.dart';
import 'package:Lifely/widgets/scaleTransition.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../data/dataHelper.dart';

class Dashboard extends StatefulWidget {
  final CupertinoTabController tabController;

  Dashboard({this.tabController});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {
      DataHelper dataHelper = Provider.of<DataHelper>(context, listen: false);

      bool isEng = AppLocalizations.of(context).locale == Locale('en', 'US');

      if (dataHelper.bigFives.length == 0) {
        dataHelper.loadBigFiveExampleData(isEng);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: false);

    String name = dataHelper.user.name;

    bool lockBig5 = !dataHelper.user.bigFiveUnlocked;

    double padding = width * 0.05;

    void openGoal() {
      print("open goal!!");
      widget.tabController.index = 2;
      NavigatorHelper.openPopup(
          context, dataHelper.getNextGoal(), true, dataHelper, null);
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            ///color: Color(0xff2d1c40).withOpacity(0.9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment
                    .bottomRight, // 10% of the width, so there are ten blinds.
                colors: [
                  Color(0xff382350).withOpacity(0.9),
                  Color(0xff2f2a5a),
                ], // whitish to gray
              ),

              //color: Colors.redAccent.withOpacity(0.8),
            ),
          ),
          MyScaleTransition(
            child: Transform.translate(
              offset: Offset(-50, -65),
              child: Transform.rotate(
                angle: 3.14 / 4,
                child: Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment
                          .bottomRight, // 10% of the width, so there are ten blinds.
                      colors: [
                        Color(0xffc7dcaf),
                        Colors.lightBlueAccent,
                      ], // whitish to gray
                      tileMode: TileMode
                          .repeated, // repeats the gradient over the canvas
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    //color: Colors.redAccent.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              width * 0.5,
              height * 0.55,
            ),
            child: Transform.rotate(
              angle: 3.14 / 5,
              child: Icon(
                FontAwesomeIcons.lightbulb,
                color: Colors.white.withOpacity(0.1),
                size: 300,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: padding, horizontal: padding),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double availableWidth = constraints.maxWidth;
                  double availableHeight = constraints.maxHeight;

                  return Column(
                    children: <Widget>[
                      //##################################### Hello Text (0.25 Höhe):
                      Container(
                        height: availableHeight * 0.25 - padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)
                                  .translate("dashboard_hello", name),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate("dashboard_welcome"),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: padding,
                      ),
                      //##################################### Box (0.3 Höhe):
                      Container(
                        height: availableHeight * 0.3 - padding,
                        child: FrostedContainer(
                          borderRadius: 23,
                          child: DashboardBox(
                            openGoal: openGoal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: padding,
                      ),
                      //######################################## Icons (0.45 Höhe):
                      Container(
                        height: availableHeight * 0.45,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: availableWidth * 0.5 - 0.5 * padding,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:
                                        availableHeight * 0.3 - 0.5 * padding,
                                    child: IconBox(
                                      icon: FontAwesomeIcons.bullseye,
                                      text: AppLocalizations.of(context)
                                          .translate("dashboard_goals"),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => GoalLetter(),
                                        ),
                                      ),
                                      gradient: true,
                                    ),
                                  ),
                                  SizedBox(
                                    height: padding,
                                  ),
                                  Container(
                                    height:
                                        availableHeight * 0.15 - 0.5 * padding,
                                    child: IconBox(
                                      icon: FontAwesomeIcons.cog,
                                      text: "",
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Settings(),
                                        ),
                                      ),
                                      gradient: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: padding,
                            ),
                            Container(
                              width: availableWidth * 0.5 - 0.5 * padding,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height:
                                        availableHeight * 0.225 - 0.5 * padding,
                                    child: IconBox(
                                      icon: lockBig5
                                          ? Icons.lock
                                          : FontAwesomeIcons.solidUser,
                                      text: AppLocalizations.of(context)
                                          .translate("dashboard_PFE"),
                                      onTap: lockBig5
                                          ? () => widget.tabController.index = 0
                                          : () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ZDELetter(),
                                                ),
                                              ),
                                      gradient: false,
                                    ),
                                  ),
                                  SizedBox(
                                    height: padding,
                                  ),
                                  Container(
                                    height:
                                        availableHeight * 0.225 - 0.5 * padding,
                                    child: IconBox(
                                      icon:
                                          lockBig5 ? Icons.lock : Icons.looks_5,
                                      text: "Big Five",
                                      onTap: lockBig5
                                          ? () => widget.tabController.index = 0
                                          : () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BigFiveLetter(),
                                                ),
                                              ),
                                      gradient: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: padding,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
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
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Text(
        AppLocalizations.of(context).translate("dashboard_boxText"),
        style: TextStyle(color: Colors.white, fontSize: 17),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final bool gradient;
  final String text;

  IconBox({this.onTap, this.text, this.icon, this.gradient});

  @override
  Widget build(BuildContext context) {
    Widget getInner() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(
                icon,
                size: icon != Icons.looks_5 ? 45 : 50,
                color: Colors.white,
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 21,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      );
    }

    Widget getOnlyIconInner() {
      return Center(
        child: FaIcon(
          icon,
          size: 33,
          color: Colors.white.withOpacity(0.95),
        ),
      );
    }

    Widget getGradient(Widget child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment
                .bottomRight, // 10% of the width, so there are ten blinds.
            colors: [
              Color(0xffc7dcaf),
              Colors.lightBlueAccent,
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: child,
      );
    }

    return FrostedContainer(
      borderRadius: 23,
      onTap: onTap,
      child: gradient
          ? getGradient((text != "" ? getInner() : getOnlyIconInner()))
          : (text != "" ? getInner() : getOnlyIconInner()),
    );
  }
}
