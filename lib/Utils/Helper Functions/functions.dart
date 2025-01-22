// Helper function to format the date
import 'package:intl/intl.dart';

String formatDate(String dateString) {
  try {
    final DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  } catch (e) {
    return dateString; // Return the original string if parsing fails
  }
}
