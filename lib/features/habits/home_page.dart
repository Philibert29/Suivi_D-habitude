import 'package:flutter/material.dart';
import 'habit_service.dart';
import './habits_model.dart';
import '/core/services/notification_service.dart';
import '/core/services/local_storage_service.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = HabitService();
  List<Habit> habits = [];
  final controller = TextEditingController();
  final List<String> daysOfWeek = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  String selectedDay = 'Lun'; // Valeur par défaut

  @override
  void initState() {
    super.initState();
    loadHabits();
  }

  Future<void> loadHabits() async {
    final data = await service.fetchTodayHabits();
    setState(() => habits = data);
  }

  Future<void> addHabit() async {
    if (controller.text.trim().isEmpty) return;
    await service.addHabit(controller.text, selectedDay);
    controller.clear();
    await loadHabits();
  }

  Future<void> toggleHabit(Habit habit) async {
    await service.toggleCompletion(habit.id, !habit.isCompleted);
    await loadHabits();
  }

  Future<void> deleteHabit(String habitId) async {
    await service.deleteHabit(habitId);
    await loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes habitudes du jour"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistiques hebdo',
            onPressed: () => Navigator.pushNamed(context, '/stats'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: "Nouvelle habitude"),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedDay,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDay = newValue!;
                    });
                  },
                  items: daysOfWeek.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addHabit,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.notifications),
              label: const Text("Choisir l'heure de rappel"),
              onPressed: () async {
                if (Platform.isWindows) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🔔 Notifications non supportées sur Windows"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  await LocalStorageService.saveNotificationTime(picked.hour, picked.minute);
                  await NotificationService.scheduleDailyNotification(
                    hour: picked.hour,
                    minute: picked.minute,
                  );

                  if (!mounted) return;

                  final formattedTime = picked.format(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Notification programmée à $formattedTime'),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (_, index) {
                final habit = habits[index];
                return ListTile(
                  leading: Checkbox(
                    value: habit.isCompleted,
                    onChanged: (_) => toggleHabit(habit),
                  ),
                  title: Text(habit.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteHabit(habit.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
