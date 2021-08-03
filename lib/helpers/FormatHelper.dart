import 'package:intl/intl.dart';

class FormatHelper {
  static today() => DateFormat('dd-MM-yyyy').format(DateTime.now());
}
