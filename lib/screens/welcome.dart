import 'package:Lifely/app_localizations.dart';
import 'package:Lifely/screens/welcomeName.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
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
                flex: 3,
                child: SizedBox(),
              ),
              Text(
                AppLocalizations.of(context).translate("welcome_hey1"),
                style: TextStyle(color: Colors.black, fontSize: 35),
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Text(
                AppLocalizations.of(context).translate("welcome_hey2"),
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Image(
                height: 150,
                width: 150,
                image: AssetImage('assets/logotransparent.png'),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Center(
                child: FrostedContainer(
                  color: Colors.teal,
                  borderRadius: 20,
                  padding: EdgeInsets.all(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeName()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate("welcome_start"),
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
