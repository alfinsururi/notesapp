import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/models/note.dart'; // Import your Note model
import 'package:path_provider/path_provider.dart';

class NotesViewModel extends ChangeNotifier {
  late List<Note> _notes;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotesViewModel(this.flutterLocalNotificationsPlugin) {
    _notes = [];
    _initialize();
  }

  List<Note> get notes => _notes;

  void _initialize() async {
    await _loadNotes();
  }

  Future<void> _loadNotes() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final notesBox = await Hive.openBox<Note>('notesBox');
    _notes = notesBox.values.toList();
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final notesBox = await Hive.openBox<Note>('notesBox');
    _notes.add(note);
    await notesBox.add(note);
    notifyListeners(); 
  }


  Future<void> deleteNote(int index) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final notesBox = await Hive.openBox<Note>('notesBox');
    await notesBox.deleteAt(index);
    _notes.removeAt(index);
    notifyListeners();
  }
}



