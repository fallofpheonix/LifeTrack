import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui' as ui;
import 'package:lifetrack/app/router/app_router.dart';
import 'package:lifetrack/core/theme/app_colors_extension.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/data/models/user_profile.dart';
import 'package:lifetrack/features/profile/widgets/medical_details_section.dart';
import 'package:lifetrack/data/models/weight_entry.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/ui/app_page_layout.dart';
import 'package:lifetrack/design_system/layout/screen_scaffold.dart';
import 'package:lifetrack/design_system/tokens/app_spacing.dart';

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
      medicalHistory: currentProfile.medicalHistory,
      allergies: currentProfile.allergies,
      emergencyContactName: currentProfile.emergencyContactName,
      emergencyContactPhone: currentProfile.emergencyContactPhone,
      emergencyContactRelation: currentProfile.emergencyContactRelation,
      insuranceProvider: currentProfile.insuranceProvider,
      insurancePolicyNumber: currentProfile.insurancePolicyNumber,
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

  Color _getBmiColor(BuildContext context, double bmi) {
    final c = context.appColors;
    if (bmi < 18.5) return c.accentFocus;
    if (bmi < 25) return c.accentRecovery;
    if (bmi < 30) return c.accentActivity;
    return Theme.of(context).colorScheme.error;
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

    return ScreenScaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
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
          const SizedBox(height: AppSpacing.xl),
          BaseCard(
            child: Padding(
              padding: EdgeInsets.zero,
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
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: WeightChartPainter(
                        entries: weightHistory,
                        lineColor: Theme.of(context).colorScheme.primary,
                        gridColor: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                        labelColor: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Center(
                    child: Text(
                      'Last 30 Days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.appColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          BaseCard(
            child: Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Health Metrics', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                           const Text('BMI'),
                           Text(bmi.toStringAsFixed(1), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getBmiColor(context, bmi))),
                           Text(_getBmiLabel(bmi), style: TextStyle(color: _getBmiColor(context, bmi), fontWeight: FontWeight.w500)),
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
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.cake_outlined)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.male)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)', prefixIcon: Icon(Icons.monitor_weight_outlined)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Height (cm)', prefixIcon: Icon(Icons.height)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
             children: <Widget>[
               Expanded(
                 child: TextField(
                   controller: _bloodController,
                   decoration: const InputDecoration(labelText: 'Blood Type', prefixIcon: Icon(Icons.bloodtype_outlined)),
                 ),
               ),
               const SizedBox(width: AppSpacing.md),
               Expanded(
                 child: TextField(
                   controller: _goalController,
                   keyboardType: TextInputType.number,
                   decoration: const InputDecoration(labelText: 'Daily Calorie Goal', prefixIcon: Icon(Icons.flag_outlined)),
                 ),
               ),
             ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const MedicalDetailsSection(),
          const SizedBox(height: AppSpacing.xl),
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
  WeightChartPainter({
    required this.entries,
    required this.lineColor,
    Color? gridColor,
    Color? labelColor,
  })  : gridColor = gridColor ?? const Color(0xFF9E9E9E),
        labelColor = labelColor ?? const Color(0xFF000000);

  final List<WeightEntry> entries;
  final Color lineColor;
  final Color gridColor;
  final Color labelColor;

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
      ..color = gridColor
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
                 style: TextStyle(color: labelColor, fontSize: 10),
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
    return oldDelegate.entries != entries ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.labelColor != labelColor;
  }
}
