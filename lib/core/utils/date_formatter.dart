import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);
}
