import 'package:intl/intl.dart';

class FormatHelper {
  static today() => DateFormat('dd-MM-yyyy').format(DateTime.now());
  static dateTime(DateTime dateTime) =>
      DateFormat('dd-MM-yyyy').format(dateTime);
}
