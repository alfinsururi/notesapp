import 'package:flutter/material.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/viewmodel/notes_view_model.dart';

import 'package:provider/provider.dart';

class EditNoteScreen extends StatefulWidget {
  final Note note;

  const EditNoteScreen({required this.note});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  DateTime? _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _noteController = TextEditingController(text: widget.note.content);
    _selectedTime = widget.note.reminderTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm),
            onPressed: _selectReminderTime,
            tooltip: 'Set Reminder',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveNote();
              Navigator.pop(context);
            },
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildNoteEditor(),
      ),
    );
  }

  Widget _buildNoteEditor() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _noteController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(fontSize: 18.0),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Start writing here...',
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
            const SizedBox(height: 20.0),
            if (_selectedTime != null)
              Text(
                'Due: ${_formatDateTime(_selectedTime!)}',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }

  void _selectReminderTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveNote() {
  final viewModel = Provider.of<NotesViewModel>(context, listen: false);
  
  
  final index = viewModel.notes.indexWhere((note) => note == widget.note);
  
  if (index != -1) {
   
    viewModel.notes[index] = Note(
      title: _titleController.text,
      content: _noteController.text,
      lastEdited: DateTime.now(),
      reminderTime: _selectedTime,
    );
  }

  
  viewModel.notifyListeners();
}


  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}


