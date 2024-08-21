import 'package:intl/intl.dart';

class TimeConvertUtils {
  static String formattedTime(DateTime time) {
    return '${time.year}-${time.month}-${time.day} ${time.hour}:${time.minute}';
  }

  static String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat('hh:mm a');
    DateFormat dateTimeFormat = DateFormat('dd MMM hh:mm a');

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return timeFormat.format(dateTime);
    } else {
      return dateTimeFormat.format(dateTime);
    }
  }

}