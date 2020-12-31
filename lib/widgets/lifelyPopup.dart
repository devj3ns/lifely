import 'dart:math';

import 'package:flutter/material.dart';

import '../app_localizations.dart';
import 'frostedContainer.dart';

class LifelyPopup extends StatelessWidget {
  final String username;
  final String text;

  LifelyPopup({this.username, this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Random random = new Random();
    bool r = random.nextBool();

    String great = AppLocalizations.of(context).translate("great");

    if (r) {
      great = AppLocalizations.of(context).translate("great2");
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.1,
          ),
          //Color muss bleiben, da sonst Gesture Detector nicht geht
          color: Colors.transparent,
          child: GestureDetector(
            //2. Gesture Detector muss bleiben, da sonst 1. Gesture Detector den ganzen Screen abdeckt
            onTap: () => null,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                FrostedContainer(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        great + ", $username! \n\n$text",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  borderRadius: 25,
                ),
                Transform.translate(
                  offset: Offset(0, -75),
                  child: Image(
                    height: 150,
                    width: 150,
                    image: AssetImage('assets/logotransparent.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
