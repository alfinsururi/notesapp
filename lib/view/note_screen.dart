import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/view/edit_note_screen.dart';
import 'package:notesapp/view/event_screen.dart';
import 'package:notesapp/viewmodel/notes_view_model.dart'; // Importing the NotesViewModel
import 'package:notesapp/models/note.dart'; // Import your Note model

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, _) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: viewModel.notes.length,
            itemBuilder: (context, index) {
              final note = viewModel.notes[index];
              String preview = note.content.length > 30
                  ? '${note.content.substring(0, 30)}...'
                  : note.content;

              return Card(
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(preview),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatDateTime(note.lastEdited)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      if (note.reminderTime != null)
                        Text(
                          '${_formatDateTime(note.reminderTime!)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(note: note),
                      ),
                    );
                  },
                  onLongPress: () {
                    viewModel.deleteNote(index);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNote(context);
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event Coming Up',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _addNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _titleController = TextEditingController();
        TextEditingController _noteController = TextEditingController();
        DateTime? selectedTime;
        return AlertDialog(
          title: const Text('Add Note'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Content'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    selectedTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selectedTime != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        selectedTime = DateTime(
                          selectedTime!.year,
                          selectedTime!.month,
                          selectedTime!.day,
                          time.hour,
                          time.minute,
                        );
                      }
                    }
                  },
                  child: const Text('Set Reminder'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<NotesViewModel>(context, listen: false).addNote(
                  Note(
                    title: _titleController.text,
                    content: _noteController.text,
                    lastEdited: DateTime.now(),
                    reminderTime: selectedTime,
                  ),
                );
                _titleController.clear();
                _noteController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

