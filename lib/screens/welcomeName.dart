import 'package:Lifely/data/userModel.dart';
import 'package:Lifely/screens/welcomeMenu.dart';
import 'package:Lifely/widgets/frostedContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_localizations.dart';
import '../data/dataHelper.dart';

class WelcomeName extends StatefulWidget {
  @override
  _WelcomeNameState createState() => _WelcomeNameState();
}

class _WelcomeNameState extends State<WelcomeName> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          children: <Widget>[
            SizedBox(
              height: height * 0.005,
            ),
            Image(
              height: 150,
              width: 150,
              image: AssetImage('assets/logotransparent.png'),
            ),
            SizedBox(
              height: height * 0.001,
            ),
            Text(
              AppLocalizations.of(context).translate("welcomeName_meet"),
              style: TextStyle(color: Colors.black, fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Center(
              child: TextField(
                decoration: InputDecoration(),
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                controller: _nameController,
                onChanged: (t) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            _nameController.text.trim().length > 1 &&
                    _nameController.text.trim().length < 13
                ? Column(
                    children: <Widget>[
                      Center(
                        child: FrostedContainer(
                          color: Colors.teal,
                          borderRadius: 25,
                          padding: EdgeInsets.all(22),
                          onTap: _nameController.text.trim().length < 1
                              ? null
                              : () {
                                  //Provider Daten ändern und abspeichern!
                                  DataHelper provider = Provider.of<DataHelper>(
                                      context,
                                      listen: false);

                                  String name = _nameController.text;
                                  name = name.trimRight();
                                  name = name.trimLeft();

                                  User user = new User(
                                    name: name,
                                    firstLoginTime: DateTime.now(),
                                    showAchievedGoals: true,
                                    bigFiveUnlocked: false,
                                  );
                                  provider.insertUser(user);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WelcomeMenu(name: name),
                                    ),
                                  );
                                },
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
