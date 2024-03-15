import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/view/edit_note_screen.dart';
import 'package:notesapp/viewmodel/notes_view_model.dart';

import 'package:provider/provider.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Coming Up'),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, viewModel, _) {
          // Sort notes by reminder time
          viewModel.notes.sort((a, b) {
            if (a.reminderTime == null && b.reminderTime == null) {
              return 0;
            } else if (a.reminderTime == null) {
              return 1;
            } else if (b.reminderTime == null) {
              return -1;
            } else {
              return a.reminderTime!.compareTo(b.reminderTime!);
            }
          });

          return ListView.builder(
            itemCount: viewModel.notes.length,
            itemBuilder: (context, index) {
              final note = viewModel.notes[index];
              if (note.reminderTime != null) {
                return InkWell(
                  onTap: () {
                    _openNoteEditor(context, note);
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        'Due Time: ${_formatDateTime(note.reminderTime!)}',
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _openNoteEditor(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(note: note),
      ),
    );
  }
}


