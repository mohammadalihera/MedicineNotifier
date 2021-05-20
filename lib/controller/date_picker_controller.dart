import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get.dart';
import 'package:medicine/models/pill.dart';
//import 'package:grinz/models/task/task.dart';

class DateSelectedTaskController extends GetxController {
  String selected_date = DateTime.now().toString();
  List<Pill> selectedDatePills = new List<Pill>().obs;

  void updateSelectedDateTasklist(DateTime date) {
    selected_date = DateFormat('dd-MM-yy').format(date).toString();
    print(selected_date);
    update();
    print(selected_date);
  }
}
