import 'package:awesome_notifications/awesome_notifications.dart';

import '../../Models/medicine.dart';

class NotificationScheduler {
  static Future<void> scheduleNotificationForMedicine(Medicine medicine) async {
    final id = medicine.id! * 1000 +
        DateTime.now().millisecondsSinceEpoch % 1000; // Unique ID
    final title = 'Reminder: ${medicine.name}';
    final body = 'Time to take ${medicine.dosage} of ${medicine.name}';
    final scheduledTime = _parseTime(medicine.time); // Parse reminder time

    if (scheduledTime != null) {
      print("Scheduling notification for $scheduledTime");
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          icon: 'resource://drawable/icon', // For Android

          id: id,
          channelKey: 'reminder_channel',
          title: title,
          body: body, // Add reminder message
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduledTime, // Schedule at the specified time
        ),
      );
    }
  }

  static DateTime? _parseTime(String time) {
    try {
      final now = DateTime.now();

      // Handle 12-hour format (e.g., "1:50 PM")
      if (time.contains("AM") || time.contains("PM")) {
        final timeParts = time.split(' '); // Split into time and period (AM/PM)
        final period = timeParts[1]; // AM or PM
        final hourMinute =
            timeParts[0].split(':'); // Split into hours and minutes

        var hour = int.parse(hourMinute[0]);
        final minute = int.parse(hourMinute[1]);

        // Convert 12-hour format to 24-hour format
        if (period == "PM" && hour != 12) {
          hour += 12;
        } else if (period == "AM" && hour == 12) {
          hour = 0;
        }

        return DateTime(now.year, now.month, now.day, hour, minute);
      }

      // Handle 24-hour format (e.g., "13:50")
      else {
        final timeParts = time.split(':');
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);

        return DateTime(now.year, now.month, now.day, hour, minute);
      }
    } catch (e) {
      print("Failed to parse time: $e");
      return null;
    }
  }
}
