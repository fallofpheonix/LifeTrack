import 'package:flutter/material.dart';

void main() {
  runApp(const LifeTrackApp());
}

class LifeTrackApp extends StatelessWidget {
  const LifeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8A6F)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        useMaterial3: true,
      ),
      home: const LifeTrackHomePage(),
    );
  }
}

class LifeTrackHomePage extends StatefulWidget {
  const LifeTrackHomePage({super.key});

  @override
  State<LifeTrackHomePage> createState() => _LifeTrackHomePageState();
}

class _LifeTrackHomePageState extends State<LifeTrackHomePage> {
  int _selectedIndex = 0;

  final HealthSnapshot _snapshot = HealthSnapshot(
    steps: 6840,
    stepsGoal: 10000,
    waterGlasses: 6,
    waterGoal: 8,
    sleepHours: 6.8,
    calories: 1520,
    caloriesGoal: 2100,
  );

  final List<ActivityLog> _activities = <ActivityLog>[
    ActivityLog(name: 'Brisk walk', durationMinutes: 35, caloriesBurned: 210),
    ActivityLog(name: 'Yoga', durationMinutes: 20, caloriesBurned: 90),
    ActivityLog(name: 'Cycling', durationMinutes: 40, caloriesBurned: 310),
  ];

  final List<MealEntry> _meals = <MealEntry>[
    MealEntry(mealType: 'Breakfast', title: 'Oats + Banana', calories: 320),
    MealEntry(mealType: 'Lunch', title: 'Paneer salad bowl', calories: 460),
    MealEntry(mealType: 'Snack', title: 'Nuts + Green tea', calories: 180),
    MealEntry(mealType: 'Dinner', title: 'Dal + Brown rice', calories: 420),
  ];

  final List<ReminderItem> _reminders = <ReminderItem>[
    ReminderItem(title: 'Drink water', timeLabel: 'Every 2 hours', enabled: true),
    ReminderItem(title: 'Take medication', timeLabel: '08:00 PM', enabled: true),
    ReminderItem(title: 'Evening walk', timeLabel: '07:00 PM', enabled: false),
  ];

  final List<DiseaseInfo> _diseaseGuide = <DiseaseInfo>[
    DiseaseInfo(
      name: 'Diabetes (Type 2)',
      symptoms: 'Frequent urination, fatigue, increased thirst',
      precautions: 'Track glucose, reduce refined sugar, regular exercise',
    ),
    DiseaseInfo(
      name: 'Hypertension',
      symptoms: 'Often asymptomatic, headache, dizziness',
      precautions: 'Low-sodium diet, weight control, daily BP monitoring',
    ),
    DiseaseInfo(
      name: 'Hypothyroidism',
      symptoms: 'Weight gain, low energy, dry skin',
      precautions: 'Take medication on time, routine thyroid tests',
    ),
    DiseaseInfo(
      name: 'Asthma',
      symptoms: 'Shortness of breath, chest tightness, wheezing',
      precautions: 'Avoid triggers, inhaler adherence, breathing exercises',
    ),
  ];

  final List<HealthRecordEntry> _records = <HealthRecordEntry>[
    HealthRecordEntry(
      dateLabel: '2026-02-10',
      condition: 'Diabetes (Type 2)',
      vitals: 'Fasting glucose 112 mg/dL',
      note: 'Morning walk completed',
    ),
    HealthRecordEntry(
      dateLabel: '2026-02-12',
      condition: 'Hypertension',
      vitals: 'BP 126/82 mmHg',
      note: 'Reduced salty snacks',
    ),
  ];

  final List<RecoveryDataPoint> _recoveryData = <RecoveryDataPoint>[
    RecoveryDataPoint(month: 'M1', fastingGlucose: 168, postMealGlucose: 238),
    RecoveryDataPoint(month: 'M2', fastingGlucose: 149, postMealGlucose: 212),
    RecoveryDataPoint(month: 'M3', fastingGlucose: 136, postMealGlucose: 194),
    RecoveryDataPoint(month: 'M4', fastingGlucose: 124, postMealGlucose: 176),
  ];

  void _addQuickActivity() {
    setState(() {
      _activities.insert(
        0,
        ActivityLog(name: 'Quick jog', durationMinutes: 15, caloriesBurned: 120),
      );
      _snapshot.steps += 1800;
      _snapshot.calories = (_snapshot.calories - 120).clamp(0, 9999);
    });
  }

  void _addWaterGlass() {
    setState(() {
      if (_snapshot.waterGlasses < 20) {
        _snapshot.waterGlasses += 1;
      }
    });
  }

  void _toggleReminder(int index, bool enabled) {
    setState(() {
      _reminders[index].enabled = enabled;
    });
  }

  void _addRecord() {
    setState(() {
      _records.insert(
        0,
        HealthRecordEntry(
          dateLabel: DateTime.now().toIso8601String().split('T').first,
          condition: 'General wellness',
          vitals: 'Weight 71 kg, Sleep 7.2 h',
          note: 'Auto sample entry',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      DashboardPage(
        snapshot: _snapshot,
        onAddWater: _addWaterGlass,
      ),
      ActivityPage(
        activities: _activities,
        onQuickLog: _addQuickActivity,
      ),
      NutritionPage(meals: _meals),
      ReminderPage(
        reminders: _reminders,
        onToggle: _toggleReminder,
      ),
      MedicalPage(
        diseaseGuide: _diseaseGuide,
        records: _records,
        recoveryData: _recoveryData,
        onAddRecord: _addRecord,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeTrack'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.directions_run), label: 'Activity'),
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Nutrition'),
          NavigationDestination(icon: Icon(Icons.notifications_none), label: 'Reminders'),
          NavigationDestination(icon: Icon(Icons.medical_information_outlined), label: 'Medical'),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.snapshot,
    required this.onAddWater,
  });

  final HealthSnapshot snapshot;
  final VoidCallback onAddWater;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        _HeroCard(snapshot: snapshot),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: <Widget>[
            MetricCard(
              icon: Icons.directions_walk,
              title: 'Steps',
              value: '${snapshot.steps}/${snapshot.stepsGoal}',
              subtitle: '${(snapshot.steps / snapshot.stepsGoal * 100).round()}% goal',
            ),
            MetricCard(
              icon: Icons.bedtime,
              title: 'Sleep',
              value: '${snapshot.sleepHours.toStringAsFixed(1)} h',
              subtitle: 'Target 8.0 h',
            ),
            MetricCard(
              icon: Icons.local_fire_department,
              title: 'Calories',
              value: '${snapshot.calories}',
              subtitle: 'Goal ${snapshot.caloriesGoal}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.water_drop)),
            title: Text('Hydration: ${snapshot.waterGlasses}/${snapshot.waterGoal} glasses'),
            subtitle: const Text('Keep water intake consistent across the day.'),
            trailing: FilledButton(
              onPressed: onAddWater,
              child: const Text('+1'),
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({
    super.key,
    required this.activities,
    required this.onQuickLog,
  });

  final List<ActivityLog> activities;
  final VoidCallback onQuickLog;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Today\'s Activity', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              onPressed: onQuickLog,
              icon: const Icon(Icons.add),
              label: const Text('Quick log'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...activities.map((ActivityLog activity) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
              title: Text(activity.name),
              subtitle: Text('${activity.durationMinutes} min'),
              trailing: Text('-${activity.caloriesBurned} kcal'),
            ),
          );
        }),
      ],
    );
  }
}

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key, required this.meals});

  final List<MealEntry> meals;

  @override
  Widget build(BuildContext context) {
    final int totalCalories = meals.fold<int>(0, (int sum, MealEntry item) => sum + item.calories);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.restaurant)),
            title: const Text('Daily Nutrition Overview'),
            subtitle: Text('Consumed calories: $totalCalories kcal'),
          ),
        ),
        const SizedBox(height: 12),
        ...meals.map((MealEntry meal) {
          return Card(
            child: ListTile(
              title: Text('${meal.mealType}: ${meal.title}'),
              trailing: Text('${meal.calories} kcal'),
            ),
          );
        }),
      ],
    );
  }
}

class ReminderPage extends StatelessWidget {
  const ReminderPage({
    super.key,
    required this.reminders,
    required this.onToggle,
  });

  final List<ReminderItem> reminders;
  final void Function(int index, bool enabled) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (BuildContext context, int index) {
        final ReminderItem reminder = reminders[index];
        return Card(
          child: SwitchListTile(
            value: reminder.enabled,
            onChanged: (bool enabled) => onToggle(index, enabled),
            title: Text(reminder.title),
            subtitle: Text(reminder.timeLabel),
          ),
        );
      },
    );
  }
}

class MedicalPage extends StatelessWidget {
  const MedicalPage({
    super.key,
    required this.diseaseGuide,
    required this.records,
    required this.recoveryData,
    required this.onAddRecord,
  });

  final List<DiseaseInfo> diseaseGuide;
  final List<HealthRecordEntry> records;
  final List<RecoveryDataPoint> recoveryData;
  final VoidCallback onAddRecord;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Disease Guide', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                const Text(
                  'Educational support only. Not a medical diagnosis.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...diseaseGuide.map((DiseaseInfo disease) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.health_and_safety)),
              title: Text(disease.name),
              subtitle: Text(
                'Symptoms: ${disease.symptoms}\nPrecautions: ${disease.precautions}',
              ),
            ),
          );
        }),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text('Health Records', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            FilledButton.icon(
              onPressed: onAddRecord,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...records.map((HealthRecordEntry record) {
          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.event_note)),
              title: Text('${record.dateLabel} - ${record.condition}'),
              subtitle: Text('${record.vitals}\n${record.note}'),
            ),
          );
        }),
        const SizedBox(height: 10),
        RecoveryTrendCard(data: recoveryData),
      ],
    );
  }
}

class RecoveryTrendCard extends StatelessWidget {
  const RecoveryTrendCard({super.key, required this.data});

  final List<RecoveryDataPoint> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Health Recovery Trend', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            const Text('Patient glucose trend (mg/dL): lower is better.'),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: CustomPaint(
                painter: RecoveryChartPainter(data: data),
                child: Container(),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              children: const <Widget>[
                _LegendDot(color: Color(0xFF1D8A6F), label: 'Fasting glucose'),
                _LegendDot(color: Color(0xFFD16F2A), label: 'Post-meal glucose'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

class RecoveryChartPainter extends CustomPainter {
  RecoveryChartPainter({required this.data});

  final List<RecoveryDataPoint> data;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      return;
    }

    const double leftPad = 34;
    const double rightPad = 10;
    const double topPad = 10;
    const double bottomPad = 24;

    final double width = size.width - leftPad - rightPad;
    final double height = size.height - topPad - bottomPad;
    if (width <= 0 || height <= 0) {
      return;
    }

    final Paint axisPaint = Paint()
      ..color = const Color(0xFF7E8896)
      ..strokeWidth = 1;
    final Paint gridPaint = Paint()
      ..color = const Color(0xFFE1E6EF)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(leftPad, topPad),
      Offset(leftPad, topPad + height),
      axisPaint,
    );
    canvas.drawLine(
      Offset(leftPad, topPad + height),
      Offset(leftPad + width, topPad + height),
      axisPaint,
    );

    final List<int> allValues = <int>[
      ...data.map((RecoveryDataPoint e) => e.fastingGlucose),
      ...data.map((RecoveryDataPoint e) => e.postMealGlucose),
    ];
    final int minValue = allValues.reduce((int a, int b) => a < b ? a : b) - 10;
    final int maxValue = allValues.reduce((int a, int b) => a > b ? a : b) + 10;
    final int span = (maxValue - minValue).clamp(1, 10000);

    for (int i = 0; i < 4; i++) {
      final double y = topPad + (height * i / 3);
      canvas.drawLine(Offset(leftPad, y), Offset(leftPad + width, y), gridPaint);
    }

    final Path fastingPath = Path();
    final Path postMealPath = Path();
    final Paint fastingPaint = Paint()
      ..color = const Color(0xFF1D8A6F)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final Paint postMealPaint = Paint()
      ..color = const Color(0xFFD16F2A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < data.length; i++) {
      final RecoveryDataPoint point = data[i];
      final double x = leftPad + (width * i / (data.length - 1).clamp(1, 10000));
      final double fastingY = topPad + height - ((point.fastingGlucose - minValue) / span) * height;
      final double postMealY = topPad + height - ((point.postMealGlucose - minValue) / span) * height;

      if (i == 0) {
        fastingPath.moveTo(x, fastingY);
        postMealPath.moveTo(x, postMealY);
      } else {
        fastingPath.lineTo(x, fastingY);
        postMealPath.lineTo(x, postMealY);
      }

      canvas.drawCircle(Offset(x, fastingY), 3, fastingPaint..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(x, postMealY), 3, postMealPaint..style = PaintingStyle.fill);
      fastingPaint.style = PaintingStyle.stroke;
      postMealPaint.style = PaintingStyle.stroke;

      final TextPainter monthPainter = TextPainter(
        text: TextSpan(
          text: point.month,
          style: const TextStyle(fontSize: 11, color: Color(0xFF556170)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      monthPainter.paint(canvas, Offset(x - monthPainter.width / 2, topPad + height + 4));
    }

    canvas.drawPath(fastingPath, fastingPaint);
    canvas.drawPath(postMealPath, postMealPaint);
  }

  @override
  bool shouldRepaint(covariant RecoveryChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final HealthSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final int stepsLeft = (snapshot.stepsGoal - snapshot.steps).clamp(0, snapshot.stepsGoal);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Welcome back', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('You are $stepsLeft steps away from your daily goal.'),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            minHeight: 8,
            borderRadius: BorderRadius.circular(100),
            value: snapshot.steps / snapshot.stepsGoal,
          ),
        ],
      ),
    );
  }
}

class HealthSnapshot {
  HealthSnapshot({
    required this.steps,
    required this.stepsGoal,
    required this.waterGlasses,
    required this.waterGoal,
    required this.sleepHours,
    required this.calories,
    required this.caloriesGoal,
  });

  int steps;
  final int stepsGoal;
  int waterGlasses;
  final int waterGoal;
  final double sleepHours;
  int calories;
  final int caloriesGoal;
}

class ActivityLog {
  ActivityLog({
    required this.name,
    required this.durationMinutes,
    required this.caloriesBurned,
  });

  final String name;
  final int durationMinutes;
  final int caloriesBurned;
}

class MealEntry {
  MealEntry({
    required this.mealType,
    required this.title,
    required this.calories,
  });

  final String mealType;
  final String title;
  final int calories;
}

class ReminderItem {
  ReminderItem({
    required this.title,
    required this.timeLabel,
    required this.enabled,
  });

  final String title;
  final String timeLabel;
  bool enabled;
}

class DiseaseInfo {
  DiseaseInfo({
    required this.name,
    required this.symptoms,
    required this.precautions,
  });

  final String name;
  final String symptoms;
  final String precautions;
}

class HealthRecordEntry {
  HealthRecordEntry({
    required this.dateLabel,
    required this.condition,
    required this.vitals,
    required this.note,
  });

  final String dateLabel;
  final String condition;
  final String vitals;
  final String note;
}

class RecoveryDataPoint {
  RecoveryDataPoint({
    required this.month,
    required this.fastingGlucose,
    required this.postMealGlucose,
  });

  final String month;
  final int fastingGlucose;
  final int postMealGlucose;
}
