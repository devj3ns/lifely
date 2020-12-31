import 'package:Lifely/data/userModel.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../app_localizations.dart';
import '../data/dataHelper.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text =
        Provider.of<DataHelper>(context, listen: false).user.name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final dataHelper = Provider.of<DataHelper>(context, listen: false);
    AppLocalizations language = AppLocalizations.of(context);

    Future<bool> _deleteDialog(BuildContext context) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              language.translate("settings_reset") + "?",
            ),
            content: Text(
              language.translate("settings_reset_confirm"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  language.translate("cancel"),
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  language.translate("settings_reset_confirm reset"),
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        },
      );
    }

    Future<bool> _changeNameDialog(BuildContext context) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(language.translate("settings_changeName")),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  language.translate("cancel"),
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  language.translate("settings_change"),
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  if (_controller.text.trim().length > 1 &&
                      _controller.text.trim().length < 13)
                    Navigator.of(context).pop(true);
                },
              )
            ],
          );
        },
      );
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
          Transform.translate(
            offset: Offset(width * 0.5, height * 0.6),
            child: Transform.rotate(
              angle: 3.14 / 5,
              child: Icon(
                Icons.settings,
                color: Colors.white.withOpacity(0.1),
                size: 300,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                        language.translate("settings_title"),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    language.translate("settings_date") +
                        DateFormat("dd.MM.").format(
                          dataHelper.user.firstLoginTime,
                        ) +
                        " :)                        ",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    language.translate("settings_rate"),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FrostedBoxButton(
                        icon: FontAwesomeIcons.star,
                        onPressed: () => _launchURL(
                            "https://play.google.com/store/apps/details?id=de.jensbecker.lifely"),
                      ),
                      FrostedBoxButton(
                        icon: FontAwesomeIcons.comments,
                        onPressed: () => _launchURL(
                            "mailto:jensbecker01@gmx.de?subject=Lifely Feedback"),
                      ),
                      FrostedBoxButton(
                        icon: FontAwesomeIcons.questionCircle,
                        onPressed: () => _launchURL(
                            "mailto:jensbecker01@gmx.de?subject=Lifely Support"),
                      ),
                      FrostedBoxButton(
                        icon: FontAwesomeIcons.instagram,
                        onPressed: () =>
                            _launchURL("https://www.instagram.com/dev.j3ns/"),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FrostedContainer(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    borderRadius: 10,
                    child: Center(
                      child: Text(
                        language.translate("settings_changeName"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () async {
                      bool result = await _changeNameDialog(context);
                      if (result == true) {
                        String name = _controller.text;
                        name = name.trimRight();
                        name = name.trimLeft();

                        User user = new User(
                          name: name,
                          firstLoginTime: dataHelper.user.firstLoginTime,
                          showAchievedGoals: dataHelper.user.showAchievedGoals,
                          bigFiveUnlocked: dataHelper.user.bigFiveUnlocked,
                        );

                        dataHelper.updateUser(user);
                      } else {
                        _controller.text = dataHelper.user.name;
                      }
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FrostedContainer(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    borderRadius: 10,
                    child: Center(
                      child: Text(
                        language.translate("settings_reset"),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () async {
                      bool result = await _deleteDialog(context);
                      if (result == true) {
                        await dataHelper.clearDataAndDatabase();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => MyApp()),
                            (Route<dynamic> route) => false);
                      }
                    },
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Text(
                      "Lifely v1.0.4 \nCreator: Jens Becker \nDesign: Evelyn Tkachenko",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
