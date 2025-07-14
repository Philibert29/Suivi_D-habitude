import 'package:supabase_flutter/supabase_flutter.dart';
import './habits_model.dart';
import 'package:uuid/uuid.dart';

class HabitService {
  final _client = Supabase.instance.client;

  Future<List<Habit>> fetchTodayHabits() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final response = await _client
        .from('habits')
        .select()
        .eq('user_id', _client.auth.currentUser!.id)
        .eq('date', today);

    return (response as List).map((h) => Habit.fromMap(h)).toList();
  }

  Future<void> addHabit(String title, String day) async {
    final userId = _client.auth.currentUser!.id;
    final habit = Habit(
      id: const Uuid().v4(),
      title: title,
      isCompleted: false,
      date: DateTime.now(),
      day: day,
      userId: userId,
    );

    await _client.from('habits').insert(habit.toMap());
  }

  Future<void> toggleCompletion(String id, bool value) async {
    await _client.from('habits').update({'is_completed': value}).eq('id', id);
  }

  Future<void> deleteHabit(String id) async {
    await _client.from('habits').delete().eq('id', id);
  }

  Future<Map<String, List<Habit>>> fetchHabitsByDay() async {
  final userId = _client.auth.currentUser!.id;
  final response = await _client
      .from('habits')
      .select()
      .eq('user_id', userId);

  final data = (response as List).map((e) => Habit.fromMap(e)).toList();

  final Map<String, List<Habit>> grouped = {};
  for (final habit in data) {
    grouped.putIfAbsent(habit.day, () => []).add(habit);
  }
  return grouped;
}



}
