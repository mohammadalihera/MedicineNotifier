import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicine/database/repository.dart';
import 'package:medicine/helpers/snack_bar.dart';
import 'package:medicine/models/medicine_type.dart';
import 'package:medicine/models/pill.dart';
import 'package:medicine/notifications/notifications.dart';
import '../../helpers/platform_flat_button.dart';
import '../../screens/add_new_medicine/form_fields.dart';
import '../../screens/add_new_medicine/medicine_type_card.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AddNewMedicine extends StatefulWidget {
  @override
  _AddNewMedicineState createState() => _AddNewMedicineState();
}

class _AddNewMedicineState extends State<AddNewMedicine> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Snackbar snackbar = Snackbar();

  //medicine types
  final List<String> weightValues = ["pills", "ml", "mg"];

  //list of medicines forms objects
  final List<MedicineType> medicineTypes = [
    MedicineType("Syrup", Image.asset("assets/images/syrup.png"), true),
    MedicineType("Pill", Image.asset("assets/images/pills.png"), false),
    MedicineType("Capsule", Image.asset("assets/images/capsule.png"), false),
    MedicineType("Cream", Image.asset("assets/images/cream.png"), false),
    MedicineType("Drops", Image.asset("assets/images/drops.png"), false),
    MedicineType("Syringe", Image.asset("assets/images/syringe.png"), false),
  ];

  //-------------Pill object------------------
  int howManyWeeks = 1;
  String selectWeight;
  DateTime setDate = DateTime.now();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  //for 3 bela notification
  bool setMn = false;
  bool setLn = false;
  bool setDn = false;
  //for 3 bela notifiaction er time
  DateTime morningTime = DateTime.now();
  DateTime lunchTime = DateTime.now();
  DateTime dinnerTime = DateTime.now();

  //==========================================

  //-------------- Database and notifications ------------------
  final Repository _repository = Repository();
  final Notifications _notifications = Notifications();

  //============================================================

  @override
  void initState() {
    super.initState();
    selectWeight = weightValues[0];
    initNotifies();
  }

  //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height - 60.0;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      appBar: AppBar(
        title: Text('Add Madicine'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 30.0, bottom: 30.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: deviceHeight * 0.05,
                //   child: FittedBox(
                //     child: InkWell(
                //       child: Icon(Icons.arrow_back),
                //       onTap: () {
                //         Navigator.pop(context);
                //       },
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: deviceHeight * 0.01,
                // ),
                // Container(
                //   padding: EdgeInsets.only(left: 15.0),
                //   height: deviceHeight * 0.05,
                //   child: FittedBox(
                //       child: Text(
                //     "Add Pills",
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline3
                //         .copyWith(color: Colors.black),
                //   )),
                // ),
                // SizedBox(
                //   height: deviceHeight * 0.03,
                // ),
                Container(
                  height: deviceHeight * 0.37,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FormFields(
                          howManyWeeks,
                          selectWeight,
                          popUpMenuItemChanged,
                          sliderChanged,
                          nameController,
                          amountController)),
                ),
                Container(
                  height: deviceHeight * 0.035,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            "Medicine form",
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.02,
                ),
                Container(
                  height: 60,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ...medicineTypes.map(
                          (type) => MedicineTypeCard(type, medicineTypeClick))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          child: PlatformFlatButton(
                            handler: () => openTimePicker(''),
                            buttonChild: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  DateFormat.Hm().format(this.setDate),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                            color: Color.fromRGBO(7, 190, 200, 0.1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          child: PlatformFlatButton(
                            handler: () => openDatePicker(),
                            buttonChild: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 10),
                                Text(
                                  DateFormat("dd.MM").format(this.setDate),
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  Icons.event,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                            color: Color.fromRGBO(7, 190, 200, 0.1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 23,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: FittedBox(
                      child: Text(
                        "Medicine Time",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            setMn = !setMn;
                            if (setMn) {
                              openTimePicker('morning');
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: setMn
                                  ? Color.fromRGBO(7, 190, 200, 1)
                                  : Colors.white),
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                  width: 20,
                                  height: 20.0,
                                  child: Icon(Icons.breakfast_dining)),
                              SizedBox(
                                height: 7.0,
                              ),
                              Container(
                                  child: Text(
                                'Breakfast Time',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            setLn = !setLn;
                            if (setLn) {
                              openTimePicker('lunch');
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: setLn
                                ? Color.fromRGBO(7, 190, 200, 1)
                                : Colors.white,
                          ),
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                  width: 20,
                                  height: 20.0,
                                  child: Icon(Icons.wb_sunny)),
                              SizedBox(
                                height: 7.0,
                              ),
                              Container(
                                  child: Text(
                                'Lunch Time',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            setDn = !setDn;
                            if (setDn) {
                              openTimePicker('dinner');
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: setDn
                                ? Color.fromRGBO(7, 190, 200, 1)
                                : Colors.white,
                          ),
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                  width: 20,
                                  height: 20.0,
                                  child: Icon(Icons.nights_stay)),
                              SizedBox(
                                height: 7.0,
                              ),
                              Container(
                                  child: Text(
                                'Dinner Time',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  height: 50,
                  width: double.infinity,
                  child: PlatformFlatButton(
                    handler: () async => savePill(),
                    color: Theme.of(context).primaryColor,
                    buttonChild: Text(
                      "Done",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //slider changer
  void sliderChanged(double value) =>
      setState(() => this.howManyWeeks = value.round());

  //choose popum menu item
  void popUpMenuItemChanged(String value) =>
      setState(() => this.selectWeight = value);

  //------------------------OPEN TIME PICKER (SHOW)----------------------------
  //------------------------CHANGE CHOOSE PILL TIME----------------------------

  Future<void> openTimePicker(String when) async {
    await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            helpText: "Choose Time")
        .then((value) {
      DateTime newDate = DateTime(
          setDate.year,
          setDate.month,
          setDate.day,
          value != null ? value.hour : setDate.hour,
          value != null ? value.minute : setDate.minute);
      setState(() => setDate = newDate);
      setState(() {
        if (when == 'morning') {
          morningTime = newDate;
          print(morningTime);
          print(lunchTime);
          print(dinnerTime);
        }
        if (when == 'lunch') {
          lunchTime = newDate;
          print(morningTime);
          print(lunchTime);
          print(dinnerTime);
        }
        if (when == 'dinner') {
          dinnerTime = newDate;
          print(morningTime);
          print(lunchTime);
          print(dinnerTime);
        }
      });
      print(newDate.hour);
      print(newDate.minute);
    });
  }

  //====================================================================

  //-------------------------SHOW DATE PICKER AND CHANGE CURRENT CHOOSE DATE-------------------------------
  Future<void> openDatePicker() async {
    await showDatePicker(
            context: context,
            initialDate: setDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 100000)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setState(() => setDate = newDate);
      print(setDate.day);
      print(setDate.month);
      print(setDate.year);
    });
  }

  //=======================================================================================================

  //--------------------------------------SAVE PILL IN DATABASE---------------------------------------
  Future savePill() async {
    //check if medicine time is lower than actual time
    if (setDate.year.milliseconds < DateTime.now().year.milliseconds &&
        setDate.month.milliseconds < DateTime.now().month.milliseconds &&
        setDate.day.milliseconds < DateTime.now().day.milliseconds) {
      snackbar.showSnack(
          "Check your medicine time and date", _scaffoldKey, null);
    } else {
      //create pill object
      Pill pill = Pill(
          amount: amountController.text,
          howManyWeeks: howManyWeeks,
          medicineForm: medicineTypes[medicineTypes
                  .indexWhere((element) => element.isChoose == true)]
              .name,
          name: nameController.text,
          time: setDate.millisecondsSinceEpoch,
          type: selectWeight,
          notifyId: Random().nextInt(10000000),
          morningTime: setMn ? morningTime.millisecondsSinceEpoch : null,
          lunchTime: setLn ? lunchTime.millisecondsSinceEpoch : null,
          dinnerTime: setDn ? dinnerTime.millisecondsSinceEpoch : null);

      //---------------------| Save as many medicines as many user checks |----------------------
      int howmandays = howManyWeeks * 7;
      for (int i = 0; i < howmandays; i++) {
        print(howManyWeeks * 7);
        dynamic result =
            await _repository.insertData("Pills", pill.pillToMap());
        print('Tota days of notification');
        if (result == null) {
          snackbar.showSnack("Something went wrong", _scaffoldKey, null);
          return;
        } else {
          //set the notification schneudele

          setDate = setDate.add(Duration(milliseconds: 86400000));
          pill.time = setDate.millisecondsSinceEpoch;
          pill.notifyId = Random().nextInt(10000000);
          tz.initializeTimeZones();
          tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
          if (setMn) {
            print(morningTime);
            await _notifications.showNotification(
                pill.name,
                pill.amount + " " + pill.medicineForm + " " + pill.type,
                morningTime
                        .add(Duration(milliseconds: 86400000))
                        .millisecondsSinceEpoch -
                    tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
                pill.notifyId,
                flutterLocalNotificationsPlugin);
          }
          if (setLn) {
            print(lunchTime);
            await _notifications.showNotification(
                pill.name,
                pill.amount + " " + pill.medicineForm + " " + pill.type,
                dinnerTime
                        .add(Duration(milliseconds: 86400000))
                        .millisecondsSinceEpoch -
                    tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
                pill.notifyId,
                flutterLocalNotificationsPlugin);
          }
          if (setDn) {
            print(dinnerTime);
            await _notifications.showNotification(
                pill.name,
                pill.amount + " " + pill.medicineForm + " " + pill.type,
                dinnerTime
                        .add(Duration(milliseconds: 86400000))
                        .millisecondsSinceEpoch -
                    tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
                pill.notifyId,
                flutterLocalNotificationsPlugin);
          }
        }
      }
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
      if (setMn) {
        print('-----------------------------------------');
        print(morningTime);
        await _notifications.showNotification(
            pill.name,
            pill.amount + " " + pill.medicineForm + " " + pill.type,
            morningTime.millisecondsSinceEpoch -
                tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
            Random().nextInt(10000000),
            flutterLocalNotificationsPlugin);
      }
      if (setLn) {
        print('lllllllllllllllllllllllllllllllllllllllllllllllllll');
        print(lunchTime);
        await _notifications.showNotification(
            pill.name,
            pill.amount + " " + pill.medicineForm + " " + pill.type,
            lunchTime.millisecondsSinceEpoch -
                tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
            Random().nextInt(10000000),
            flutterLocalNotificationsPlugin);
      }
      if (setDn) {
        print('dddddddddddddddddddddddddddddddddddddd');
        print(dinnerTime);
        await _notifications.showNotification(
            pill.name,
            pill.amount + " " + pill.medicineForm + " " + pill.type,
            dinnerTime.millisecondsSinceEpoch -
                tz.TZDateTime.now(tz.local).millisecondsSinceEpoch,
            Random().nextInt(10000000),
            flutterLocalNotificationsPlugin);
      }
      //---------------------------------------------------------------------------------------
      snackbar.showSnack("Saved", _scaffoldKey, null);
      Navigator.pop(context);
    }
  }

  //=================================================================================================

  //----------------------------CLICK ON MEDICINE FORM CONTAINER----------------------------------------
  void medicineTypeClick(MedicineType medicine) {
    setState(() {
      medicineTypes.forEach((medicineType) => medicineType.isChoose = false);
      medicineTypes[medicineTypes.indexOf(medicine)].isChoose = true;
    });
  }

  //=====================================================================================================

  //get time difference
  int get time =>
      setDate.millisecondsSinceEpoch -
      tz.TZDateTime.now(tz.local).millisecondsSinceEpoch;
}
