import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final _client = Supabase.instance.client;
  Map<String, int> habitsPerDay = {
    'Lun': 0,
    'Mar': 0,
    'Mer': 0,
    'Jeu': 0,
    'Ven': 0,
    'Sam': 0,
    'Dim': 0,
  };
  int totalDone = 0;
  int totalAvailable = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

Future<void> loadStats() async {
  final response = await _client
      .from('habits')
      .select()
      .eq('user_id', _client.auth.currentUser!.id);

  final list = response as List<dynamic>;

  // Reset des compteurs
  Map<String, int> countByDay = {
    'Lun': 0,
    'Mar': 0,
    'Mer': 0,
    'Jeu': 0,
    'Ven': 0,
    'Sam': 0,
    'Dim': 0,
  };

  int completed = 0;
  int available = 0;

  for (var item in list) {
    final fullDay = item['day'] as String? ?? '';
    final shortDay = _shortenDay(fullDay);

    if (countByDay.containsKey(shortDay)) {
      available++; // ← seulement si le jour est valide
      if (item['is_completed'] == true) {
        countByDay[shortDay] = countByDay[shortDay]! + 1;
        completed++;
      }
    }
  }

  setState(() {
    habitsPerDay = countByDay;
    totalDone = completed;
    totalAvailable = available; // ← on utilise le vrai total
  });
}



  /// Convertit "Lundi" → "Lun", etc.
  String _shortenDay(String fullDay) {
    const map = {
      'Lundi': 'Lun',
      'Mardi': 'Mar',
      'Mercredi': 'Mer',
      'Jeudi': 'Jeu',
      'Vendredi': 'Ven',
      'Samedi': 'Sam',
      'Dimanche': 'Dim',
      'Lun': 'Lun',
      'Mar': 'Mar',
      'Mer': 'Mer',
      'Jeu': 'Jeu',
      'Ven': 'Ven',
      'Sam': 'Sam',
      'Dim': 'Dim',
    };
    return map[fullDay] ?? fullDay;
  }

  String _weekdayLabel(int weekday) {
    const days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[weekday - 1];
  }

  List<BarChartGroupData> _buildBarChartData() {
    return [
      for (var i = 0; i < 7; i++)
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: habitsPerDay[_weekdayLabel(i + 1)]!.toDouble(),
              width: 16,
            ),
          ],
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final completionRate =
        totalAvailable == 0 ? 0 : (totalDone / totalAvailable * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques Hebdo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Taux de complétion : $completionRate%",
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarChartData(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = [
                            'Lun',
                            'Mar',
                            'Mer',
                            'Jeu',
                            'Ven',
                            'Sam',
                            'Dim'
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Affiche uniquement les entiers (ex : 0, 1, 2...)
                          if (value % 1 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            );
                          } else {
                            return const SizedBox.shrink(); // Cache les décimales
                          }
                        },
                        reservedSize: 28,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
