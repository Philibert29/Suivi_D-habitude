import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/auth_page.dart';
import 'features/habits/home_page.dart';
import 'features/stats/stats_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/services/notification_service.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de Supabase
  await Supabase.initialize(
    url: 'https://phauvminrjcbyhmnqluu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBoYXV2bWlucmpjYnlobW5xbHV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI0MzYzNDcsImV4cCI6MjA2ODAxMjM0N30.2cP3MwEQ53vMoKUX-qg2j6CvzJSAs_vm8kOy7POUT6g',
  );

  await NotificationService.init();

  // Initialisation des notifications locales
  if (!Platform.isWindows) {
    const initializationSettings = InitializationSettings(
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  } else {
    debugPrint("⚠️ Notifications non supportées sur Windows.");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suivi Habitude',
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthPage(),
        '/home': (_) => const HomePage(),
        '/stats': (_) => const StatsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
