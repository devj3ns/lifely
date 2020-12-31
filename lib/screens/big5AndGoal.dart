import 'dart:async';
import 'dart:math';
import 'package:Lifely/data/userModel.dart';
import 'package:Lifely/widgets/bigFivesList.dart';

import 'package:Lifely/data/dataHelper.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:Lifely/widgets/goalsList.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../navigatorHelper.dart';

class Big5AndGoal extends StatefulWidget {
  final bool goals;
  final String title;
  final String subtitle;
  final Color secondColor;

  Big5AndGoal({
    this.goals,
    this.title,
    this.subtitle,
    this.secondColor,
  });

  @override
  _Big5AndGoal createState() => _Big5AndGoal();
}

class _Big5AndGoal extends State<Big5AndGoal> {
  ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController(duration: Duration(seconds: 1));

    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void runSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool bigFiveUnlocked =
        Provider.of<DataHelper>(context, listen: false).user.bigFiveUnlocked;

    if (bigFiveUnlocked == null) {
      bigFiveUnlocked = false;
    }

    bool showBig5LockedScreen = !widget.goals && !bigFiveUnlocked;

    void showConfetti() {
      print("show confetti :)");
      _confettiController.play();
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            //color: Color(0xff382350).withOpacity(0.9),
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
            offset: Offset(-50, -65),
            child: Transform.rotate(
              angle: 3.14 / 4,
              child: Container(
                height: 350,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: widget.secondColor.withOpacity(0.8),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: widget.goals
                      ? GoalsList(
                          padding: width * 0.05,
                          confetti: showConfetti,
                        )
                      : BigFivesList(
                          padding: width * 0.05,
                          confetti: showConfetti,
                        ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 75,
            ),
          ),
          showBig5LockedScreen
              ? Locked(confetti: showConfetti, runSetState: runSetState)
              : SizedBox(),
        ],
      ),
    );
  }
}

class Locked extends StatefulWidget {
  final Function confetti;
  final Function runSetState;

  Locked({this.confetti, this.runSetState});

  @override
  _LockedState createState() => _LockedState();
}

class _LockedState extends State<Locked> {
  Timer _everySecond;

  @override
  void initState() {
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    if (_everySecond != null) {
      _everySecond?.cancel();
      _everySecond = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataHelper dataHelper = Provider.of<DataHelper>(context, listen: false);
    AppLocalizations language = AppLocalizations.of(context);

    openLifelyPopup() {
      String text = language.translate("big5_lifelyPopup");
      NavigatorHelper.openLifelyPopup(context, text, dataHelper.user.name);
    }

    Duration duration = dataHelper.durationUntilBigFiveUnlocked();

    if (duration.isNegative) {
      if (_everySecond != null) {
        _everySecond?.cancel();
        _everySecond = null;
        print("timer stopped and deleted");
      }

      duration = Duration.zero;
    }

    String timeLeft = duration.inHours.toString().padLeft(2, '0') +
        " : " +
        duration.inMinutes.remainder(60).toString().padLeft(2, '0') +
        " : " +
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');

    String name = dataHelper.user.name;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    List<Widget> getLockedColumn() {
      return [
        Image(
          height: 175,
          width: 175,
          image: AssetImage('assets/logotransparent.png'),
        ),
        Column(
          children: <Widget>[
            Text(
              language.translate("big5_lock_info"),
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Text(
              timeLeft,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Text(
              language.translate("big5_lock_info2"),
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Icon(
          Icons.lock,
          size: 80,
          color: Colors.white,
        ),
      ];
    }

    List<Widget> getUnlockedColumn() {
      return [
        Image(
          height: 175,
          width: 175,
          image: AssetImage('assets/logotransparent.png'),
        ),
        Column(
          children: <Widget>[
            Text(
              language.translate("big5_lock_timeOver", name),
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        GestureDetector(
          child: Icon(
            Icons.lock_open,
            size: 80,
            color: Colors.white,
          ),
          onTap: () {
            widget.confetti();
            widget.runSetState();

            //update User:
            User user = new User(
              name: dataHelper.user.name,
              firstLoginTime: dataHelper.user.firstLoginTime,
              bigFiveUnlocked: true,
              showAchievedGoals: dataHelper.user.showAchievedGoals,
            );
            Provider.of<DataHelper>(context, listen: false).updateUser(user);

            openLifelyPopup();
          },
        ),
      ];
    }

    return FrostedContainer(
      borderRadius: 0,
      padding: EdgeInsets.all(width * 0.05),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: duration == Duration.zero
              ? getUnlockedColumn()
              : getLockedColumn(),
        ),
      ),
    );
  }
}
