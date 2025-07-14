class Habit {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime date;
  final String day;
  final String userId;


  Habit({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.date,
    required this.day,
    required this.userId,
  });

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      isCompleted: map['is_completed'],
      date: DateTime.parse(map['date']),
      day: map['day'],
      userId: map['user_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'is_completed': isCompleted,
      'date': date.toIso8601String(),
      'day': day, // ici aussi
      'user_id': userId,
    };
  }
}