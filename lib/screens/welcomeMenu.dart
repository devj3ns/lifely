import 'package:Lifely/screens/LetterScreen.dart';
import 'package:Lifely/tabBar.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/material.dart';

import '../app_localizations.dart';

class WelcomeMenu extends StatelessWidget {
  final String name;
  WelcomeMenu({this.name});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: SizedBox(),
              ),
              Text(
                AppLocalizations.of(context)
                    .translate("welcomeMenu_goals", name),
                style: TextStyle(color: Colors.black, fontSize: 30),
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              Center(
                child: FrostedContainer(
                  color: Colors.teal,
                  borderRadius: 16,
                  padding: EdgeInsets.all(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GoalLetter(
                          fromWelcomeMenu: true,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("welcomeMenu_readGoals"),
                    style: TextStyle(color: Colors.black, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Center(
                child: FrostedContainer(
                  color: Colors.green,
                  borderRadius: 18,
                  padding: EdgeInsets.all(17),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyTabBar()),
                        (Route<dynamic> route) => false);
                  },
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("welcomeMenu_dashboard"),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
