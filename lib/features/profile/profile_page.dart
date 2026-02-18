import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'package:lifetrack/core/ui/base_card.dart'; // Added import
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/features/settings/settings_page.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _genderController;
  late TextEditingController _bloodController;
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    // We can read the initial value securely here as long as provider is initialized.
    final store = ref.read(lifeTrackStoreProvider);
    final userProfile = store.userProfile;
    final currentGoal = store.snapshot.caloriesGoal;

    _nameController = TextEditingController(text: userProfile.name);
    _ageController = TextEditingController(text: userProfile.age.toString());
    _weightController = TextEditingController(text: userProfile.weight.toString());
    _heightController = TextEditingController(text: userProfile.height.toString());
    _genderController = TextEditingController(text: userProfile.gender);
    _bloodController = TextEditingController(text: userProfile.bloodType);
    _goalController = TextEditingController(text: currentGoal.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _genderController.dispose();
    _bloodController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _save() {
    final store = ref.read(lifeTrackStoreProvider);
    final currentProfile = store.userProfile;

    final UserProfile newProfile = UserProfile(
      id: currentProfile.id, // Preserve ID
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text) ?? currentProfile.age,
      weight: double.tryParse(_weightController.text) ?? currentProfile.weight,
      height: double.tryParse(_heightController.text) ?? currentProfile.height,
      gender: _genderController.text.trim(),
      bloodType: _bloodController.text.trim(),
      // Preserve others
      createdAt: currentProfile.createdAt,
      updatedAt: DateTime.now(), 
    );
    final int newGoal = int.tryParse(_goalController.text) ?? store.snapshot.caloriesGoal;
    
    store.updateProfile(newProfile, newGoal);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
  }

  void _showAddWeightDialog() async {
    final TextEditingController weightInputController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Weight Entry'),
        content: TextField(
          controller: weightInputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Weight (kg)', suffixText: 'kg'),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final double? val = double.tryParse(weightInputController.text);
              if (val != null) {
                ref.read(lifeTrackStoreProvider).addWeightEntry(WeightEntry(date: DateTime.now().toUtc(), weightKg: val));
                _weightController.text = val.toString(); // Sync with profile input
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getBmiLabel(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(lifeTrackStoreProvider);
    final userProfile = store.userProfile;
    final weightHistory = store.weightHistory;
    
    final double bmi = userProfile.bmi;
    final double bodyFat = userProfile.bodyFatPercentage;
    final int bmr = userProfile.bmr;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: AppPageLayout(
        child: ListView(
          children: <Widget>[
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 20),
          BaseCard(
            child: Padding( // BaseCard already has padding but custom child might want more or structure
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('Weight Trend', style: Theme.of(context).textTheme.titleLarge),
                       IconButton(
                         icon: const Icon(Icons.add, size: 20),
                         onPressed: _showAddWeightDialog,
                         tooltip: 'Add Weight Entry',
                       ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: WeightChartPainter(
                        entries: weightHistory,
                        lineColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(child: Text('Last 30 Days', style: TextStyle(color: Colors.grey, fontSize: 12))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          BaseCard(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Health Metrics', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           const Text('BMI'),
                           Text(bmi.toStringAsFixed(1), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getBmiColor(bmi))),
                           Text(_getBmiLabel(bmi), style: TextStyle(color: _getBmiColor(bmi), fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           const Text('Body Fat'),
                           Text('${bodyFat.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                           const Text('Estimate'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           const Text('BMR'),
                           Text('$bmr kcal', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                           const Text('Daily Need'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.male)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)', prefixIcon: Icon(Icons.monitor_weight_outlined)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Height (cm)', prefixIcon: Icon(Icons.height)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
             children: <Widget>[
               Expanded(
                 child: TextField(
                   controller: _bloodController,
                   decoration: const InputDecoration(labelText: 'Blood Type', prefixIcon: Icon(Icons.bloodtype_outlined)),
                 ),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: TextField(
                   controller: _goalController,
                   keyboardType: TextInputType.number,
                   decoration: const InputDecoration(labelText: 'Daily Calorie Goal', prefixIcon: Icon(Icons.flag_outlined)),
                 ),
               ),
             ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Save Profile'),
          ),
        ],
      ),
      ),
    );
  }
}

class WeightChartPainter extends CustomPainter {
  WeightChartPainter({required this.entries, required this.lineColor});

  final List<WeightEntry> entries;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty) return;

    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    // Draw grid lines
    final double gridStep = size.height / 4;
    for (int i = 0; i <= 4; i++) {
        final double y = i * gridStep;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (entries.length < 2) {
         // Just draw a dot in the middle if only one entry
         canvas.drawCircle(Offset(size.width / 2, size.height / 2), 4, dotPaint);
         return;
    }

    // Determine Y range
    double minWeight = entries.fold(999.0, (min, e) => e.weightKg < min ? e.weightKg : min);
    double maxWeight = entries.fold(0.0, (max, e) => e.weightKg > max ? e.weightKg : max);
    
    // Add padding to range
    if (maxWeight == minWeight) {
        maxWeight += 5;
        minWeight -= 5;
    } else {
        final double range = maxWeight - minWeight;
        maxWeight += range * 0.1;
        minWeight -= range * 0.1;
    }

    final double yRange = maxWeight - minWeight;

    // We assume entries are sorted by date.
    // We will evenly space them on X axis for simplicity, 
    // or we could use time scale but for "Last 30 days" simple spacing is often okay for a sparkline.
    // Let's use simple spacing.
    
    final double xStep = size.width / (entries.length - 1);
    
    final Path path = Path();
    for (int i = 0; i < entries.length; i++) {
        final double x = i * xStep;
        // Normalize weight to 0..1 then scale to height (inverted y)
        final double normalizedY = (entries[i].weightKg - minWeight) / yRange;
        final double y = size.height - (normalizedY * size.height);
        
        if (i == 0) {
            path.moveTo(x, y);
        } else {
            path.lineTo(x, y);
        }
        
        canvas.drawCircle(Offset(x, y), 4, dotPaint);
        
        // Draw label for first and last
        if (i == 0 || i == entries.length - 1) {
             final TextSpan span = TextSpan(
                 style: const TextStyle(color: Colors.black, fontSize: 10),
                 text: '${entries[i].weightKg}kg',
             );
             final TextPainter tp = TextPainter(
                 text: span,
                 textDirection: ui.TextDirection.ltr,
             );
             tp.layout();
             tp.paint(canvas, Offset(x - tp.width / 2, y - 15));
        }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WeightChartPainter oldDelegate) {
    return oldDelegate.entries != entries;
  }
}
