// given a habit list of completion day
// is the habit completed today

import 'package:habit_tracker_app/models/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();

  return completedDays.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}

// prepare the heatmap dataset
Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completedDays) {
      // normalize date to avoid time mismatch
      final normailizedDate = DateTime(date.year, date.month, date.day);

      // if the data already exist in the dataset increment it count

      if (dataset.containsKey(normailizedDate)) {
        dataset[normailizedDate] = dataset[normailizedDate]! + 1;
      } else {
        // intialize it with count 1
        dataset[normailizedDate] = 1;
      }
    }
  }
  return dataset;
}
