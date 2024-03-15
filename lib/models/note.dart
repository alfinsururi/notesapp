import 'package:hive/hive.dart';

part 'note.g.dart'; 

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late DateTime lastEdited;

  @HiveField(3)
  late DateTime? reminderTime;

  Note({
    required this.title,
    required this.content,
    required this.lastEdited,
    this.reminderTime,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      lastEdited: DateTime.parse(map['lastEdited']),
      reminderTime: map['reminderTime'] != null
          ? DateTime.parse(map['reminderTime'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'lastEdited': lastEdited.toIso8601String(),
      'reminderTime': reminderTime != null ? reminderTime!.toIso8601String() : null,
    };
  }
}

