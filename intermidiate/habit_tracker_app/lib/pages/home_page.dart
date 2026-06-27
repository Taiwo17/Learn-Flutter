import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker_app/components/my_drawer.dart';
import 'package:habit_tracker_app/components/my_habit_tile.dart';
import 'package:habit_tracker_app/components/my_heat_map.dart';
import 'package:habit_tracker_app/database/habit_database.dart';
import 'package:habit_tracker_app/models/habit.dart';
import 'package:habit_tracker_app/utils/habit.utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read exiting habit on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabit();
    super.initState();
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  // create a new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "Create a new habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // pop the box
              Navigator.of(context).pop();

              // clear controller
              textController.clear();
            },
            child: Text('Save'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.of(context).pop();

              // clear controller
              textController.clear();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // check habit on and off
  void checkHabit(bool? value, Habit habit) {
    // update the habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit box
  void editHabitBox(Habit habit) {
    // set the controller's text to the habit current name
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              // get the new habit name
              String newHabitName = textController.text;

              // save to db
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                newHabitName,
              );

              // pop the box
              Navigator.of(context).pop();

              // clear controller
              textController.clear();
            },
            child: Text('Save'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.of(context).pop();

              // clear controller
              textController.clear();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Are you sure, you want to delete?'),
        actions: [
          // delete button
          MaterialButton(
            onPressed: () {
              //
              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop the box
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),

          // Cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          // HEATMAP
          _buildHeatMap(),

          // HABIT LIST
          _buildHabitList(),
        ],
      ),
    );
  }

  // build heat map

  Widget _buildHeatMap() {
    // habit datase
    final habitDatabase = context.watch<HabitDatabase>();

    // current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return heatmap ui

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the data is available -> build heatmap

        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        }
        // handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    // current habit
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list habit of UI
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile UI
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabit(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
