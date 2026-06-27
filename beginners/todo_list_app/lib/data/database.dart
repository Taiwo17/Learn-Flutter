import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List todoList = [];

  // reference the box

  final _myBox = Hive.box('mybox');

  // Run this method if this is the first time opening the app
  void createInitialData() {
    todoList = [
      ['Make Tutorial', false],
      ['Do Exercise', false],
    ];
  }

  // load the data from database
  Future<void> loadData() async {
    todoList = await _myBox.get('TODOLIST') ?? [];
  }

  // Update the Database

  void updateDatabase() {
    _myBox.put('TODOLIST', todoList);
  }
}
