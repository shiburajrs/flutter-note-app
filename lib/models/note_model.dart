

class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime time;
  final String label;
  final int? backgroundColor;
  final bool isPinned;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.label,
    this.backgroundColor,
    this.isPinned = false,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'label': label,
      'backgroundColor': backgroundColor,
      'isPinned': isPinned ? 1 : 0,
    };
  }


  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      time: DateTime.parse(map['time'] as String),
      label: map['label'] as String,
      backgroundColor: map['backgroundColor'] as int?,
      isPinned: (map['isPinned'] as int?) == 1,
    );
  }


}
