import 'package:intl/intl.dart';

class TFormatter {
  static String formateDate(DateTime? date) {
    date ??= DateTime.now();

    return DateFormat('dd-MM-yyyy').format(date);
  }
  // static String formatedPhoneNumber(String phoneNumber){

  // }
}
