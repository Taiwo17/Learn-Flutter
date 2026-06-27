import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // INITIALIZE DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // List of Notes

  final List<Note> currentNotes = [];

  // CREATE - a note and save to db

  Future<void> addNote(String textFromUser) async {
    // create a new note object
    final newNote = Note()..text = textFromUser;

    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    // re-read from db
    fetchNote();
  }

  // READ - notes from db
  Future<void> fetchNote() async {
    List<Note> fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // UPDATE - a note in db

  Future<void> updateNotes(int id, String newText) async {
    final existingNote = await isar.notes.get(id);

    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNote();
    }
  }

  // DELETE - a note from a db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));

    await fetchNote();
  }
}
