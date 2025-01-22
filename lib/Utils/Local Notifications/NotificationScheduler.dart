import 'package:workmanager/workmanager.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import '../../Models/medicine.dart';

class NotificationScheduler {
  static Future<void> scheduleNotificationsForMedicine(
      Medicine medicine) async {
    try {
      // Validate medicine data
      if (!medicine.isValid()) {
        print("Error: Medicine data is incomplete");
        return;
      }

      // Parse the scheduled times
      final scheduledTimes = medicine.scheduledTimes;
      if (scheduledTimes.isEmpty) {
        print("Error: No valid times found");
        return;
      }

      // Iterate over each scheduled time and schedule a notification
      for (var i = 0; i < scheduledTimes.length; i++) {
        final scheduledTime = scheduledTimes[i];
        if (scheduledTime == null) {
          print("Error: Failed to parse time at index $i");
          continue;
        }

        // Ensure the scheduled time is in the future
        if (scheduledTime.isBefore(DateTime.now())) {
          print("Error: Scheduled time at index $i is in the past");
          continue;
        }

        // Generate a unique ID for the notification
        final id = medicine.id! * 1000 + i; // Ensure `medicine.id` is not null

        // Schedule the notification using WorkManager
        await Workmanager().registerOneOffTask(
          "medicine_reminder_$id", // Unique task name
          "medicine_reminder_task", // Task type
          inputData: <String, dynamic>{
            'id': id,
            'title': 'Reminder: ${medicine.name}',
            'body':
                'Time to take ${medicine.dosage} ${medicine.type} of ${medicine.name}',
          },
          initialDelay: scheduledTime.difference(DateTime.now()),
        );

        print(
            "Scheduled notification for ${medicine.name} at $scheduledTime (ID: $id)");
      }
    } catch (e) {
      print("Error scheduling notifications: $e");
      // Handle the error (e.g., display an error message to the user)
    }
  }
}
