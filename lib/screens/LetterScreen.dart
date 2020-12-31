import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;

import '../app_localizations.dart';
import '../tabBar.dart';

class GoalLetter extends StatelessWidget {
  final fromWelcomeMenu;

  GoalLetter({this.fromWelcomeMenu});

  @override
  Widget build(BuildContext context) {
    AppLocalizations language = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return TipsScreen(
      title: language.translate("letter_goalsetting"),
      readingTime: language.translate("letter_goal_readingtime"),
      icon: Transform.translate(
        offset: Offset(width * 0.4, height * -0.1),
        child: FaIcon(
          FontAwesomeIcons.bullseye,
          color: Color(0xff382350).withOpacity(0.05),
          size: 250,
        ),
      ),
      child: Column(
        children: <Widget>[
          HtmlText(
            source: false,
            text: AppLocalizations.of(context)
                .translate("letter_goalsetting_text"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: language.locale == Locale('de', 'DE')
                    ? AssetImage('assets/smartmethode.png')
                    : AssetImage('assets/smartmethodeeng.png'),
              ),
            ),
          ),
          HtmlText(
            source: false,
            text: AppLocalizations.of(context)
                .translate("letter_goalsetting_text2"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: HtmlText(
              source: false,
              text: AppLocalizations.of(context).translate("letter_lifely"),
            ),
          ),
          HtmlText(
            source: true,
            text: AppLocalizations.of(context)
                .translate("letter_goalsetting_source"),
          ),
          DashboardButton(fromWelcomeMenu != null ? fromWelcomeMenu : false),
        ],
      ),
    );
  }
}

class BigFiveLetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppLocalizations language = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return TipsScreen(
      title: language.translate("letter_bigfive"),
      readingTime: language.translate("letter_bigfive_readingtime"),
      icon: Transform.translate(
        offset: Offset(width * 0.4, height * -0.05),
        child: FaIcon(
          Icons.looks_5,
          color: Color(0xff382350).withOpacity(0.05),
          size: 250,
        ),
      ),
      child: Column(
        children: <Widget>[
          HtmlText(
            source: false,
            text: AppLocalizations.of(context).translate("letter_bigfive_text"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: HtmlText(
              source: false,
              text: AppLocalizations.of(context).translate("letter_lifely"),
            ),
          ),
          HtmlText(
            source: true,
            text:
                AppLocalizations.of(context).translate("letter_bigfive_source"),
          ),
          DashboardButton(false),
        ],
      ),
    );
  }
}

class ZDELetter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppLocalizations language = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return TipsScreen(
      title: language.translate("letter_pfe"),
      readingTime: language.translate("letter_pfe_readingtime"),
      icon: Transform.translate(
        offset: Offset(width * 0.44, height * 0),
        child: FaIcon(
          FontAwesomeIcons.solidUser,
          color: Color(0xff382350).withOpacity(0.05),
          size: 200,
        ),
      ),
      child: Column(
        children: <Widget>[
          HtmlText(
            source: false,
            text: AppLocalizations.of(context).translate("letter_pfe_text"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: HtmlText(
              source: false,
              text: AppLocalizations.of(context).translate("letter_lifely"),
            ),
          ),
          HtmlText(
            source: true,
            text: AppLocalizations.of(context).translate("letter_pfe_source"),
          ),
          DashboardButton(false),
        ],
      ),
    );
  }
}

class TipsScreen extends StatelessWidget {
  final String title;
  final String readingTime;
  final Widget child;
  final Widget icon;

  TipsScreen({this.title, this.child, this.readingTime, this.icon});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          children: <Widget>[
            Stack(
              children: <Widget>[
                icon,
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Row(
                      children: <Widget>[
                        FrostedBoxButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icons.arrow_back_ios,
                          size: 25,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    Center(
                      child: Text(
                        readingTime,
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.05,
                    ),
                    child,
                    SizedBox(
                      height: width * 0.05,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HtmlText extends StatelessWidget {
  final String text;
  final bool source;

  HtmlText({this.text, this.source});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: "<p>" + text + "</p>",
      defaultTextStyle:
          TextStyle(color: source ? Colors.grey : Colors.black, fontSize: 19),
      linkStyle: const TextStyle(
        color: Colors.redAccent,
        decorationColor: Colors.redAccent,
        decoration: TextDecoration.underline,
      ),
      onLinkTap: (url) {
        print("Opening $url...");
      },
      customTextAlign: (dom.Node node) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "p":
              return TextAlign.justify;
          }
        }
        return null;
      },
    );
  }
}

class DashboardButton extends StatelessWidget {
  final bool fromWelcomeMenu;

  DashboardButton(this.fromWelcomeMenu);

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      onTap: () {
        if (fromWelcomeMenu) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => MyTabBar()));
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.home,
            color: Colors.white,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            AppLocalizations.of(context).translate("letter_backtothedashboard"),
            style: TextStyle(color: Colors.white, fontSize: 19),
          ),
        ],
      ),
      borderRadius: 10,
      padding: EdgeInsets.all(13),
    );
  }
}
