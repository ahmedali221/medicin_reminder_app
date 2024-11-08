import 'dart:async';

import 'package:riverpod/riverpod.dart';

var dateSelected = StateProvider<DateTime>((ref) => DateTime.now());
var dayOfDate = StateProvider<int>((ref) => DateTime.now().day);

final dateSelectedProvider = StreamProvider<DateTime>((ref) {
  final controller = StreamController<DateTime>.broadcast();

  // Implement logic to update the StreamController (e.g., user interaction, timer)
  void updateDate(DateTime newDate) {
    controller.add(newDate);
  }

  // Return the Stream that emits updates
  return controller.stream;
});
