import 'dart:io';

import 'package:intl/intl.dart';
import 'package:Lifely/data/goalModel.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconpicker/Models/IconPack.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../app_localizations.dart';
import '../data/dataHelper.dart';
import '../navigatorHelper.dart';
import 'frostedContainer.dart';

class Popup extends StatefulWidget {
  final Goal data;
  final bool isGoal;
  final DataHelper provider;
  final Function confetti;

  Popup({this.data, this.isGoal, this.provider, this.confetti});

  @override
  _PopupState createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  var _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime _date;
  IconData _icon;
  List<ChecklistItem> _checklist;

  bool showSaveButton = false;
  bool showChooseIconWarning = false;
  bool showEditIconText = false;

  @override
  void initState() {
    _titleController.text = widget.data.title;
    _descriptionController.text = widget.data.description;
    _noteController.text = widget.data.note;
    _date = widget.data.date;
    _icon = widget.data.icon;
    _checklist = widget.data.checklist != null ? widget.data.checklist : [];

    _dateController.text =
        _date != null ? DateFormat('dd.MM.yyyy').format(_date) : "";

    if (widget.data.achieved == null) {
      widget.data.achieved = false;
    }

    if (_icon == null) {
      showEditIconText = true;
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    _checklist = null;
    //checkliste wird trotzdem irgendwie nicht richtig gelöscht! bleibt in cache
    _icon = null;
    _date = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    FocusScopeNode currentFocus = FocusScope.of(context);
    AppLocalizations language = AppLocalizations.of(context);

    Color uiColor = widget.isGoal ? Colors.indigoAccent : Color(0xffFE2A72);

    String getDaysLeft() {
      if (widget.data.date != null) {
        DateTime today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        int days = widget.data.date.difference(today).inDays;

        if (days.isNegative) return language.translate("popup_date_past");

        if (days == 0) {
          return language.translate("popup_date_today");
        }

        if (days == 1) return language.translate("popup_date_tomorrow");

        if (days > 30 && days < 365) {
          int months = (days / 30).round();

          if (months > 6)
            return "(> 6 " + language.translate("popup_date_months") + ")";

          if (months == 1)
            return "(> 1 " + language.translate("popup_date_month") + ")";

          return "(> " +
              months.toString() +
              " " +
              language.translate("popup_date_months") +
              ")";
        }

        if (days > 365)
          return "(> 1 " + language.translate("popup_date_year") + ")";

        return "(" +
            days.toString() +
            " " +
            language.translate("popup_date_days") +
            ")";
      }
      return "";
    }

    Color daysLeftColor() {
      String text = getDaysLeft();
      if (text == language.translate("popup_date_today") ||
          text == language.translate("popup_date_tomorrow")) {
        return Colors.redAccent;
      }

      return Colors.grey;
    }

    openLifelyPopup(String text) {
      NavigatorHelper.openLifelyPopup(context, text, widget.provider.user.name);
    }

    //speichert die Daten von den Input Controllern etc. in widget.data
    void saveDataToDataObject() {
      widget.data.note = _noteController.text;
      widget.data.title = _titleController.text;
      widget.data.description = _descriptionController.text;
      widget.data.icon = _icon != null ? _icon : widget.data.icon;
      widget.data.date = _date;
      widget.data.checklist = _checklist;
    }

    //update Goal in Database
    void updateGoalInDB() {
      saveDataToDataObject();
      if (!widget.isGoal) {
        widget.provider.updateBigFive(widget.data);
      } else {
        widget.provider.updateGoal(widget.data);
      }
    }

    //insert new Goal to Database
    void insertGoalToDB() {
      saveDataToDataObject();
      widget.data.id = DateTime.now().millisecondsSinceEpoch;

      widget.provider.insertGoal(widget.data);
    }

    //save: update in db or insert to db
    void save() {
      widget.data.id == null ? insertGoalToDB() : updateGoalInDB();
    }

    //close keyboard, open lifely popup on first goal, save
    void onSavedPressed() {
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      //icon warning
      if (_icon == null) {
        setState(() {
          showChooseIconWarning = true;
        });
      } else {
        if (showChooseIconWarning == true) {
          setState(() {
            showChooseIconWarning = false;
          });
        }
      }

      if (_formKey.currentState.validate() && _icon != null) {
        if (widget.provider.goals.length == 0 && widget.isGoal) {
          Navigator.of(context).pop();
          widget.confetti();

          String text = language.translate("popup_lifelyPopup_firstGoal");

          openLifelyPopup(text);
        }

        //save
        save();

        print(widget.data.date);
        setState(() {
          showSaveButton = false;
        });
      }
    }

    //delete goal from db and close popup
    void deleteGoalFromDB() {
      if (widget.isGoal) {
        widget.provider.deleteGoal(widget.data);
      } else {
        widget.provider.deleteBigFive(widget.data);
      }

      Navigator.of(context).pop();
    }

    _pickIcon() async {
      IconData icon = await FlutterIconPicker.showIconPicker(context,
          iconPackMode: IconPack.fontAwesomeIcons,
          iconSize: 30,
          iconPickerShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(language.translate("popup_chooseIcon"),
              style: TextStyle(fontWeight: FontWeight.bold)),
          closeChild: Text(
            language.translate("close"),
            textScaleFactor: 1.25,
          ),
          searchHintText: language.translate("popup_searchIcon"),
          noResultsText: language.translate("popup_noIcon"));

      setState(() {
        if (icon != null) {
          _icon = icon;

          showChooseIconWarning = false;
          showEditIconText = false;
          showSaveButton = true;
        }
      });

      debugPrint('Picked Icon:  $icon');
    }

    Future<String> getImageFilePath() async {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String filePath = appDocPath + "/" + widget.data.id.toString() + ".jpg";
      return filePath;
    }

    Future deleteImage() async {
      String filePath = await getImageFilePath();
      File(filePath).delete();
    }

    Future<bool> _asyncConfirmDialogDelete(BuildContext context) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(language.translate("popup_delete") + "?"),
            content: Text(language.translate("popup_delete_confirm")),
            actions: <Widget>[
              FlatButton(
                child: Text(language.translate("cancel")),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  language.translate("delete"),
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

    Future<bool> _asyncConfirmDialogClear(BuildContext context) async {
      return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(language.translate("popup_clear") + "?"),
            content: Text(language.translate("popup_clear_confirm")),
            actions: <Widget>[
              FlatButton(
                child: Text(language.translate("cancel")),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(
                  language.translate("popup_clear_clear"),
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

    void goalAchieved() {
      //update goal data
      saveDataToDataObject();
      widget.data.achieved = true;
      widget.data.achievedDate = DateTime.now();
      widget.provider.updateGoal(widget.data);

      //close popup and show lifely popup
      Navigator.of(context).pop();
      widget.confetti();
      String text = language.translate("popup_lifelyPopup_firstGoalAchieved");

      if (widget.provider.achievedGoals > 1) {
        text = language.translate("popup_lifelyPopup_goalAchieved",
            (widget.provider.achievedGoals).toString());
      }
      openLifelyPopup(text);
    }

    void clearGoal() async {
      bool result = await _asyncConfirmDialogClear(context);

      if (result) {
        _noteController.clear();
        _titleController.clear();
        _descriptionController.clear();
        _dateController.clear();
        _date = null;
        if (widget.isGoal) {
          _icon = null;
        }
        _checklist = [];
        await deleteImage();

        setState(() {
          showSaveButton = true;
          showEditIconText = true;
        });
      }
    }

    void popupMenuSelected(String choice) async {
      if (choice == "clear") {
        clearGoal();
      } else if (choice == "delete") {
        bool result = await _asyncConfirmDialogDelete(context);
        if (result) deleteGoalFromDB();
      } else if (choice == "goalAchieved") {
        goalAchieved();
      }
    }

    //für Checkliste
    void showSaveButtonFunction() {
      setState(() {
        showSaveButton = true;
      });
    }

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: Theme(
        data: new ThemeData(
          primaryColor: uiColor,
          fontFamily: "Nunito",
        ),
        child: Stack(
          children: <Widget>[
            FrostedContainer(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(width * 0.05),
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FrostedBoxButton(
                              icon: Icons.expand_more,
                              onPressed: () => Navigator.of(context).pop()),
                          Expanded(
                            child: SizedBox(),
                          ),
                          widget.data.achievedDate != null
                              ? Text(
                                  language.translate("popup_goalAchievedDate") +
                                      "\n" +
                                      DateFormat("dd.MM.yyyy")
                                          .format(widget.data.achievedDate),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.85),
                                    fontSize: 18,
                                  ),
                                  softWrap: true,
                                )
                              : SizedBox(),
                          Expanded(
                            child: SizedBox(),
                          ),
                          showSaveButton
                              ? FrostedBoxButton(
                                  icon: Icons.save,
                                  onPressed: onSavedPressed,
                                )
                              : FrostedBoxButtonMenu(
                                  onSelected: popupMenuSelected,
                                  showGoalAchieved: widget.isGoal &&
                                      widget.data.id != null &&
                                      !widget.data.achieved,
                                  showDelete:
                                      widget.isGoal && widget.data.id != null,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              cursorColor: uiColor,
                              decoration: InputDecoration(
                                hintText:
                                    language.translate("popup_chooseTitle"),
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              controller: _titleController,
                              onChanged: (_) {
                                setState(() {
                                  showSaveButton = true;
                                });
                              },
                              validator: (value) {
                                if (value.trim().length == 0) {
                                  return language
                                      .translate("popup_chooseTitleWarning");
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      widget.isGoal
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: width * 0.05,
                                ),
                                Row(
                                  children: <Widget>[
                                    IconBox(
                                      data: widget.data,
                                      onTap: _pickIcon,
                                      showEditIconText: showEditIconText,
                                      icon: _icon,
                                      warning: showChooseIconWarning,
                                    ),
                                    SizedBox(
                                      width: width * 0.05,
                                    ),
                                    Expanded(
                                      child: DateTimeField(
                                        controller: _dateController,
                                        resetIcon: Icon(
                                          Icons.clear,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        cursorColor: uiColor,
                                        decoration: InputDecoration(
                                          focusColor: uiColor,
                                          suffixStyle:
                                              TextStyle(color: daysLeftColor()),
                                          suffixText: getDaysLeft(),
                                          hintText: language
                                              .translate("popup_chooseDate"),
                                          hintStyle: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.5)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: uiColor,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        format: DateFormat("dd.MM.yyyy"),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                            context: context,
                                            locale: language.locale,
                                            firstDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                        },
                                        onChanged: (_newDate) {
                                          setState(() {
                                            _date = _newDate;
                                            showSaveButton = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: (height * 0.005).round(),
                              cursorColor: uiColor,
                              decoration: InputDecoration(
                                focusColor: uiColor,
                                hintText:
                                    language.translate("popup_description"),
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.5)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: uiColor,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              controller: _descriptionController,
                              onChanged: (_) {
                                setState(() {
                                  showSaveButton = true;
                                });
                              },
                              validator: (value) {
                                if (value.trim().length == 0) {
                                  return language
                                      .translate("popup_descriptionWarning");
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: width * 0.05,
                      ),
                      Container(
                        height: height * 0.4,
                        width: width,
                        child: SwipeSection(
                          page1Child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: (height * 0.015).round(),
                            cursorColor: uiColor,
                            decoration: InputDecoration(
                              focusColor: uiColor,
                              hintText: widget.isGoal
                                  ? language.translate("popup_noteTip")
                                  : null,
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              labelText: language.translate("popup_note"),
                              labelStyle: TextStyle(color: Colors.white),
                              alignLabelWithHint: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: uiColor,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            controller: _noteController,
                            onChanged: (_) {
                              setState(() {
                                showSaveButton = true;
                              });
                            },
                          ),
                          page2Child: Checklist(
                            checklist: _checklist,
                            showSaveButton: showSaveButtonFunction,
                            isGoal: widget.isGoal,
                          ),
                          page3Child: ImageSection(data: widget.data),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
              borderRadius: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class Checklist extends StatefulWidget {
  final List<ChecklistItem> checklist;
  final Function showSaveButton;
  final bool isGoal;

  Checklist({
    this.checklist,
    this.showSaveButton,
    this.isGoal,
  });
  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  List<TextEditingController> textEditingControllers = [];
  List<FocusNode> focusNodes = [];

  void addChecklistItem() {
    widget.checklist.add(new ChecklistItem(text: "", done: false));
    widget.showSaveButton();
  }

  void deleteChecklistItem(int index) {
    widget.checklist.removeAt(index);
    textEditingControllers.removeAt(index);
    focusNodes.removeAt(index);

    widget.showSaveButton();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations language = AppLocalizations.of(context);
    Color uiColor = widget.isGoal ? Colors.indigoAccent : Color(0xffFE2A72);
    int i = -1;

    int achievedChecklistItems = 0;
    widget.checklist.forEach((ChecklistItem item) {
      if (item.done) {
        achievedChecklistItems++;
      }
    });

    double progressPercent = achievedChecklistItems / widget.checklist.length;

    return widget.checklist.isNotEmpty
        ? Column(children: [
            LinearPercentIndicator(
              lineHeight: 15.0,
              percent: progressPercent,
              backgroundColor: Color(0xff382350).withOpacity(0.7),
              progressColor: uiColor.withOpacity(0.7),
            ),
            Column(
              children: widget.checklist.map((ChecklistItem checklistItem) {
                i++;

                textEditingControllers.insert(i,
                    new TextEditingController(text: widget.checklist[i].text));

                focusNodes.insert(i, new FocusNode());

                return ChecklistItemWidget(
                  checklistItem: widget.checklist[i],
                  showSaveButton: widget.showSaveButton,
                  deleteChecklistItem: deleteChecklistItem,
                  index: i,
                  controller: textEditingControllers[i],
                  color: uiColor,
                );
              }).toList(),
            ),
            widget.checklist.length < 5 && widget.checklist.isNotEmpty
                ? ChecklistAddButton(
                    color: uiColor,
                    onTap: addChecklistItem,
                  )
                : SizedBox(),
          ])
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.list,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                language.translate("popup_checklist_add"),
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              ChecklistAddButton(
                color: uiColor,
                onTap: addChecklistItem,
              )
            ],
          );
  }
}

class ChecklistAddButton extends StatelessWidget {
  final Function onTap;
  final Color color;

  ChecklistAddButton({this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
      child: FrostedContainer(
          padding: EdgeInsets.all(10),
          borderRadius: 10,
          color: color,
          onTap: onTap,
          child: Center(
            child: Icon(Icons.add, color: Colors.white),
          )),
    );
  }
}

class ChecklistItemWidget extends StatefulWidget {
  final ChecklistItem checklistItem;
  final Function showSaveButton;
  final Function deleteChecklistItem;
  final int index;
  final TextEditingController controller;
  final Color color;

  ChecklistItemWidget({
    this.checklistItem,
    this.showSaveButton,
    this.deleteChecklistItem,
    this.index,
    this.controller,
    this.color,
  });

  @override
  _ChecklistItemWidgetState createState() => _ChecklistItemWidgetState();
}

class _ChecklistItemWidgetState extends State<ChecklistItemWidget> {
  FocusNode focus = new FocusNode();

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length));

    return Row(
      children: <Widget>[
        Checkbox(
            activeColor: widget.color,
            value: widget.checklistItem.done,
            onChanged: (b) {
              setState(() {
                widget.checklistItem.done = b;
              });
              widget.showSaveButton();
            }),
        Expanded(
          child: TextFormField(
            focusNode: focus,
            cursorColor: widget.color,
            decoration: InputDecoration(
              focusColor: widget.color,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              suffixIcon: focus.hasFocus
                  ? IconButton(
                      onPressed: () {
                        focus.unfocus();

                        widget.deleteChecklistItem(widget.index);
                      },
                      icon: Icon(Icons.delete),
                    )
                  : null,
            ),
            style: new TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            controller: widget.controller,
            onChanged: (t) {
              widget.checklistItem.text = t;

              widget.showSaveButton();
            },
          ),
        ),
      ],
    );
  }
}

class FrostedBoxButtonMenu extends StatelessWidget {
  final Function onSelected;
  final bool showDelete;
  final bool showGoalAchieved;

  FrostedBoxButtonMenu(
      {this.onSelected, this.showDelete, this.showGoalAchieved});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    AppLocalizations language = AppLocalizations.of(context);

    var list = [
      PopupMenuItem(
          value: "clear", child: Text(language.translate("popup_clear")))
    ];

    if (showDelete) {
      list.add(PopupMenuItem(
          value: "delete", child: Text(language.translate("popup_delete"))));
    }

    if (showGoalAchieved) {
      list.insert(
          0,
          PopupMenuItem(
              value: "goalAchieved",
              child: Text(language.translate("popup_goalAchieved"))));
    }

    return Container(
      width: width * 0.15,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: FrostedContainer(
          child: PopupMenuButton(
            onSelected: onSelected,
            padding: EdgeInsets.all(0),
            icon: Icon(
              Icons.more_vert,
              size: 30,
              color: Colors.white,
            ),
            itemBuilder: (_) => list,
          ),
          borderRadius: 10,
          padding: EdgeInsets.all(5),
        ),
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  final Goal data;
  final Function onTap;
  final bool showEditIconText;
  final IconData icon;
  final bool warning;

  IconBox(
      {this.data, this.onTap, this.showEditIconText, this.icon, this.warning});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    AppLocalizations language = AppLocalizations.of(context);

    return Container(
      width: width * 0.15,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  icon == null ? FontAwesomeIcons.icons : icon,
                  color: Colors.white,
                  size: showEditIconText ? 25 : 35,
                ),
                onPressed: onTap,
              ),
              showEditIconText
                  ? Text(
                      language.translate("popup_chooseIcon2"),
                      style:
                          TextStyle(color: warning ? Colors.red : Colors.white),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class SwipeSection extends StatelessWidget {
  final Widget page1Child;
  final Widget page2Child;
  final Widget page3Child;

  SwipeSection({this.page1Child, this.page2Child, this.page3Child});

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 5),
            child: page1Child,
          );
        } else if (index == 1) {
          return page2Child;
        }
        return page3Child;
      },
      itemCount: 3,
      pagination: new SwiperPagination(
        builder: SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
          int i = config.activeIndex;
          print(i);
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
              SizedBox(
                width: 5,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 7,
                  width: 7,
                  color: i == 2 ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              )
            ],
          );
        }),
        margin: EdgeInsets.only(bottom: 0),
      ),
    );
  }
}

class ImageSection extends StatefulWidget {
  final Goal data;

  ImageSection({this.data});

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  File _image;

  //kopie hiervon oben in main popup!
  Future<String> getFilePath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String filePath = appDocPath + "/" + widget.data.id.toString() + ".jpg";
    return filePath;
  }

  Future<File> getLocalFile() async {
    String filePath = await getFilePath();
    return File(filePath);
  }

  Future<File> writeFile(File image) async {
    File file = await getLocalFile();

    imageCache.evict(FileImage(file));
    imageCache.clear();

    String filePath = await getFilePath();

    final File localImage = await image.copy(filePath);
    return localImage;
  }

  Future pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (widget.data.id != null) {
      File savedFile = await writeFile(image);
    }

    setState(() {
      _image = image;
    });
  }

  Future deleteImage() async {
    String filePath = await getFilePath();
    File(filePath).delete();

    setState(() {
      _image = null;
    });
  }

  Future getImage() async {
    String filePath = await getFilePath();
    bool exists = await File(filePath).exists();
    if (!exists) {
      return;
    }
    File img = await getLocalFile();
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations language = AppLocalizations.of(context);

    Widget getPickWidgets() {
      return widget.data.id == null
          ? Center(
              child: Text(
                language.translate("popup_image_savebefore"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : MaterialButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.image,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    language.translate("popup_image_pick"),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                pickImage();
              },
            );
    }

    return _image == null
        ? getPickWidgets()
        : Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: ExtendedImage.file(
                    _image,
                    fit: BoxFit.scaleDown,
                    enableMemoryCache: true,
                    mode: ExtendedImageMode.gesture,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.black38,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: deleteImage,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
