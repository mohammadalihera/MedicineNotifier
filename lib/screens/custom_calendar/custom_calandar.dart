import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine/controller/date_picker_controller.dart';
import 'package:medicine/database/repository.dart';
//import 'package:get/get.dart';
//import 'package:multi_select_item/multi_select_item.dart';
import 'package:table_calendar/table_calendar.dart';
//import 'package:grinz/controllers/date_selected_tasklist_controllers/date_selected_task_controller.dart';
//import '../../../controllers/tab_controller/tab_controller.dart';
//import 'package:grinz/models/task/task.dart';
//import '../../../controllers/calendar_task_controller/calendar_task_controller.dart';
import 'package:medicine/models/pill.dart';

class CustomCalendar extends StatefulWidget {
  //final String format;
  final List<Pill> listOfMedicines;
  CustomCalendar(this.listOfMedicines);

  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  //final MultiSelectController controller = new MultiSelectController();
  CalendarController _calendarController;
  final DateSelectedTaskController dateSelectedController =
      Get.put(DateSelectedTaskController(), permanent: true);
  // final CalendarTaskController taskC = Get.put(CalendarTaskController());
  // CustomTabController tabselectedController = Get.put(CustomTabController());
  List<Pill> allListOfPills = List<Pill>();
  final Repository _repository = Repository();
  Map<DateTime, List<Pill>> pilmap = new Map<DateTime, List<Pill>>();
  @override
  void initState() {
    _calendarController = CalendarController();
    setData();
    super.initState();
  }

  Future setData() async {
    allListOfPills.clear();
    (await _repository.getAllData("Pills")).forEach((pillMap) {
      allListOfPills.add(Pill().pillMapToObject(pillMap));
    });
    // chooseDay(_daysList[_lastChooseDay])
    // for (int i = 0; i < allListOfPills.length; i++) {
    //   DateTime pillDate =
    //       DateTime.fromMicrosecondsSinceEpoch(allListOfPills[i].time * 1000);
    //   DateTime date = new DateTime(
    //     pillDate.year,
    //     pillDate.month,
    //     pillDate.day,
    //   );
    //   pilmap[date].add(allListOfPills[i]);
    // }
    List<Pill> sortPil = allListOfPills;

    if (sortPil != null) {
      for (int i = 0; i < sortPil.length; i++) {
        DateTime pillDate =
            DateTime.fromMicrosecondsSinceEpoch(sortPil[i].time * 1000);
        DateTime date = new DateTime(
          pillDate.year,
          pillDate.month,
          pillDate.day,
        );
        List<Pill> tempPil = [];
        //tempPil.add(sortPil[i]);
        for (int j = 0; j < sortPil.length; j++) {
          print('#############################################');
          DateTime.fromMicrosecondsSinceEpoch(sortPil[j].time * 1000);
          DateTime nextDate = new DateTime(
            pillDate.year,
            pillDate.month,
            pillDate.day,
          );

          print(date);
          print(nextDate);
          if (date == nextDate) {
            print('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
            tempPil.add(sortPil[j]);
            print(tempPil.length);
            print('lplplplplplplplp');
            print(sortPil.length);
            sortPil.remove(sortPil[j]);
            print('lalalaallalalallaala');
            print(sortPil.length);
            j--;
          }
        }
        //sortPil.remove(sortPil[i]);
        //print('***********************************************');
        print(sortPil.length);
        pilmap[date] = tempPil;
        print(tempPil.length);
        print(pilmap[date].length);
        tempPil.clear();
        print(
            '---------------------------------------------------------------');
      }
    }
  }

  // void addMapPill() {
  //   if (allListOfPills != null) {
  //     for (int i = 0; i < allListOfPills.length; i++) {
  //       if(i==0){
  //       DateTime pillDate =
  //           DateTime.fromMicrosecondsSinceEpoch(allListOfPills[i].time * 1000);
  //       DateTime date = new DateTime(
  //         pillDate.year,
  //         pillDate.month,
  //         pillDate.day,
  //       );
  //       List<Pill> tempPil= [allListOfPills[i]];
  //       for(int j=i+1;j<allListOfPills.length;j++){
  //        if(allListOfPills[i].time==allListOfPills[j].time){
  //          tempPil.add(allListOfPills[j]);
  //        }
  //       }
  //       pilmap[date].add(allListOfPills[i]);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double dayBox = size.width * 0.143;
    double leftMargin = dayBox * 0.11;
    double afterLeftmargin = dayBox - leftMargin;
    // if (widget.format == 'month') {
    print(widget.listOfMedicines.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              //events: taskC.mp,
              rowHeight: 55,
              initialCalendarFormat: CalendarFormat.month,
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextBuilder: (date, locale) {
                  return DateFormat.E(locale).format(date).toUpperCase();
                },
                weekdayStyle: TextStyle(
                  fontFamily: "AvenirNextCyr",
                  //color: Color(0xFF4E6786),
                ),
              ),
              headerStyle: HeaderStyle(
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color(0xFF4E6786),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color(0xFF4E6786),
                ),
                titleTextStyle: TextStyle(
                  fontFamily: "AvenirNextCyr",
                  //color: Colors.white,
                  fontSize: 18,
                ),
                formatButtonVisible: false,
                formatButtonShowsNext: false,
              ),
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onDaySelected: (date, events, holidays) {},
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) {
                  // print("how many events" + events.length.toString());
                  return Container(
                    margin: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0x324E6786),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xFF4E6786),
                      ),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontFamily: "AvenirNextCyr",
                        //color: Colors.white,
                      ),
                    ),
                  );
                },
                todayDayBuilder: (context, date, events) => Container(
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0x1EFDD32A),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Color(0x79FDD32A),
                    ),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontFamily: "AvenirNextCyr",
                      //color: Colors.white,
                    ),
                  ),
                ),
                // markersBuilder: (context, date, events, holidays) {
                //   final children = <Widget>[];
                //   print(events);

                //   if (events.isNotEmpty) {
                //     children.add(
                //       Positioned(
                //         right: 1,
                //         bottom: 1,
                //         child: _buildEventsMarker(date, events, size),
                //       ),
                //     );
                //   }

                //   if (holidays.isNotEmpty) {
                //     children.add(
                //       Positioned(
                //         right: -2,
                //         top: -2,
                //         child: _buildHolidaysMarker(),
                //       ),
                //     );
                //   }

                //   return children;
                // },
              ),
              weekendDays: [DateTime.friday, DateTime.saturday],
              calendarStyle: CalendarStyle(
                contentPadding:
                    EdgeInsets.only(bottom: 0, left: 8.0, right: 8.0),
                outsideStyle: TextStyle(
                  fontFamily: "AvenirNextCyr",
                  //color: Color(0xFF47515E),
                ),
                weekdayStyle: TextStyle(
                  fontFamily: "AvenirNextCyr",
                  // color: Colors.white,
                ),
                todayStyle: TextStyle(
                  fontFamily: "AvenirNextCyr",
                  fontSize: 16,
                  //color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // } else {
    //   return TableCalendar(
    //     //events: taskC.mp,
    //     rowHeight: 55,
    //     initialCalendarFormat: CalendarFormat.week,
    //     daysOfWeekStyle: DaysOfWeekStyle(
    //         dowTextBuilder: (date, locale) {
    //           return DateFormat.E(locale).format(date).toUpperCase();
    //         },
    //         weekdayStyle: TextStyle(
    //           fontFamily: "AvenirNextCyr",
    //           //color: Color(0xFF4E6786),
    //         )),
    //     headerStyle: HeaderStyle(
    //       headerMargin: EdgeInsets.only(top: 8),
    //       leftChevronIcon: Icon(
    //         Icons.chevron_left,
    //         //color: Color(0xFF4E6786),
    //       ),
    //       rightChevronIcon: Icon(
    //         Icons.chevron_right,
    //         //color: Color(0xFF4E6786),
    //       ),
    //       titleTextStyle: TextStyle(
    //         fontFamily: "AvenirNextCyr",
    //         //color: Colors.white,
    //         fontSize: 18,
    //       ),
    //       centerHeaderTitle: true,
    //       formatButtonDecoration: BoxDecoration(
    //         color: Color(0xffFD942A),
    //         borderRadius: BorderRadius.circular(5.0),
    //       ),
    //     ),
    //     calendarController: _calendarController,
    //     startingDayOfWeek: StartingDayOfWeek.sunday,
    //     // onDaySelected: (date, events, holidays) {
    //     //   Get.find<CustomTabController>()
    //     //       .updateTabColor(Get.find<CustomTabController>().index);
    //     //   //create event here
    //     //   dateSelectedController.selectedDateTasks = new List<Task>().obs;
    //     //   if (events != null) {
    //     //     for (int i = 0; i < events.length; ++i) {
    //     //       dateSelectedController.selectedDateTasks.add(events[i]);
    //     //     }
    //     //   }
    //     //   Get.find<CustomTabController>()
    //     //       .updateTabColor(Get.find<CustomTabController>().index);
    //     // },
    //     builders: CalendarBuilders(
    //       selectedDayBuilder: (context, date, events) {
    //         Size size = MediaQuery.of(context).size;
    //         print(size);
    //         // if (events != null) {
    //         //   return ConstrainedBox(
    //         //     constraints: BoxConstraints(
    //         //       minHeight: 50,
    //         //       minWidth: 50,
    //         //       //minHeight: 65,
    //         //       //minWidth: 55,
    //         //     ),
    //         //     child: Container(
    //         //       margin: EdgeInsets.only(top: 5, bottom: 5, left: 4, right: 4),
    //         //       alignment: Alignment.center,
    //         //       decoration: BoxDecoration(
    //         //         color: Color(0x324E6786),
    //         //         borderRadius: BorderRadius.circular(5),
    //         //         /* border: Border.all(
    //         //                 color: Color(0xFF4E6786),
    //         //               ), */
    //         //       ),
    //         //       child: Text(
    //         //         date.day.toString(),
    //         //         style: TextStyle(
    //         //           fontFamily: "AvenirNextCyr",
    //         //           //color: Colors.white,
    //         //           fontSize: 16,
    //         //         ),
    //         //       ),
    //         //     ),
    //         //   );
    //         // } else {
    //         return ConstrainedBox(
    //           constraints: BoxConstraints(
    //               minHeight: size.height * 0.07, minWidth: size.width * 0.13
    //               //minHeight: 65,
    //               //minWidth: 55,
    //               ),
    //           child: Container(
    //             margin: EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 4),
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: Color(0x324E6786),
    //               borderRadius: BorderRadius.circular(5),
    //               border: Border.all(
    //                 color: Color(0xFF4E6786),
    //               ),
    //             ),
    //             child: Text(
    //               date.day.toString(),
    //               style: TextStyle(
    //                 fontFamily: "AvenirNextCyr",
    //                 // color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //       // },
    //       todayDayBuilder: (context, date, events) {
    //         // if (events != null) {
    //         //   return ConstrainedBox(
    //         //     constraints: BoxConstraints(
    //         //       minHeight: 50,
    //         //       minWidth: 50,
    //         //     ),
    //         //     child: Container(
    //         //       margin: EdgeInsets.only(top: 5, bottom: 5, left: 4, right: 4),
    //         //       alignment: Alignment.center,
    //         //       decoration: BoxDecoration(
    //         //         color: Color(0x1EFD942A),
    //         //         borderRadius: BorderRadius.circular(5),
    //         //         border: Border.all(
    //         //           color: Color(0x79FD942A),
    //         //         ),
    //         //       ),
    //         //       child: Text(
    //         //         date.day.toString(),
    //         //         style: TextStyle(
    //         //           fontFamily: "AvenirNextCyr",
    //         //           //color: Colors.white,
    //         //           fontSize: 16,
    //         //         ),
    //         //       ),
    //         //     ),
    //         //   );
    //         // } else {
    //         return ConstrainedBox(
    //           constraints: BoxConstraints(
    //             minHeight: 50,
    //             minWidth: 50,
    //           ),
    //           child: Container(
    //             margin: EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 4),
    //             alignment: Alignment.center,
    //             decoration: BoxDecoration(
    //               color: Color(0x1EFD942A),
    //               borderRadius: BorderRadius.circular(5),
    //               border: Border.all(
    //                 color: Color(0x79FD942A),
    //               ),
    //             ),
    //             child: Text(
    //               date.day.toString(),
    //               style: TextStyle(
    //                 fontFamily: "AvenirNextCyr",
    //                 //color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         );
    //       },
    //       // },
    //       // markersBuilder: (context, date, events, holidays) {
    //       //   final children = <Widget>[];

    //       //   if (events.isNotEmpty) {
    //       //     children.add(
    //       //       Positioned(
    //       //         left: size.width * 0.0152,
    //       //         //right: 4,
    //       //         bottom: size.height * 0.00943,
    //       //         //top:15,
    //       //         child: _buildEventsMarker(date, events, size),
    //       //       ),
    //       //     );
    //       //   }

    //       //   if (holidays.isNotEmpty) {
    //       //     children.add(
    //       //       Positioned(
    //       //         right: -2,
    //       //         top: -2,
    //       //         child: _buildHolidaysMarker(),
    //       //       ),
    //       //     );
    //       //   }

    //       //   return children;
    //       // },
    //     ),
    //     weekendDays: [DateTime.friday, DateTime.saturday],
    //     calendarStyle: CalendarStyle(
    //       eventDayStyle: TextStyle(
    //         fontFamily: "AvenirNextCyr",
    //         //color: Colors.white,
    //         fontSize: 16,
    //       ),
    //       outsideStyle: TextStyle(
    //         fontFamily: "AvenirNextCyr",
    //         color: Color(0xFF47515E),
    //       ),
    //       weekdayStyle: TextStyle(
    //           fontFamily: "AvenirNextCyr",
    //           //color: Colors.white,
    //           fontSize: 16),
    //       todayStyle: TextStyle(
    //         fontFamily: "AvenirNextCyr",
    //         fontSize: 16,
    //         // color: Colors.white,
    //       ),
    //       weekendStyle: TextStyle(
    //         fontFamily: "AvenirNextCyr",
    //         color: Colors.red,
    //         fontSize: 16,
    //       ),
    //     ),
    //   );
    // }
  }

  Widget _buildEventsMarker(DateTime date, List events, Size size) {
    return Container(
      height: 41,
      width: size.width * 0.10555,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xff4E6786),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 34,
          ),
          Container(
            height: 2,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color(0xffFD942A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }
}
