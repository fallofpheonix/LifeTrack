import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/core/database/health_database.dart';
import 'package:lifetrack/core/database/repositories/activity_repository.dart';
import 'package:lifetrack/core/database/repositories/drift_activity_repository.dart';
import 'package:lifetrack/core/database/repositories/drift_hydration_repository.dart';
import 'package:lifetrack/core/database/repositories/drift_nutrition_repository.dart';
import 'package:lifetrack/core/database/repositories/drift_vitals_repository.dart';
import 'package:lifetrack/core/database/repositories/hydration_repository.dart';
import 'package:lifetrack/core/database/repositories/nutrition_repository.dart';
import 'package:lifetrack/core/database/repositories/vitals_repository.dart';
import 'package:lifetrack/features/analytics/domain/services/health_analytics_service.dart';
import 'package:lifetrack/shared/models/date_range.dart';
import 'package:lifetrack/shared/models/daily_aggregates.dart';

final healthDatabaseProvider = Provider<HealthDatabase>((ref) {
  final db = HealthDatabase();
  ref.onDispose(db.close);
  return db;
});

final vitalsRepositoryProvider = Provider<VitalsRepository>((ref) {
  return DriftVitalsRepository(ref.watch(healthDatabaseProvider));
});

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return DriftActivityRepository(ref.watch(healthDatabaseProvider));
});

final hydrationRepositoryProvider = Provider<HydrationRepository>((ref) {
  return DriftHydrationRepository(ref.watch(healthDatabaseProvider));
});

final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return DriftNutritionRepository(ref.watch(healthDatabaseProvider));
});

final healthAnalyticsServiceProvider = Provider<HealthAnalyticsService>((ref) {
  return const HealthAnalyticsService();
});

final analyticsDateRangeProvider = StateProvider<DateRange>((ref) {
  final DateTime now = DateTime.now();
  final DateTime start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
  final DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
  return DateRange(start: start, end: end);
});

final vitalDailyAggregateProvider =
    FutureProvider.family<List<VitalDailyAggregate>, DateRange>((ref, range) async {
  final repo = ref.watch(vitalsRepositoryProvider);
  return repo.aggregateDaily(range.start, range.end);
});

final activityDailyAggregateProvider =
    FutureProvider.family<List<ActivityDailyAggregate>, DateRange>((ref, range) async {
  final repo = ref.watch(activityRepositoryProvider);
  return repo.aggregateDaily(range.start, range.end);
});

final hydrationDailyAggregateProvider =
    FutureProvider.family<List<HydrationDailyAggregate>, DateRange>((ref, range) async {
  final repo = ref.watch(hydrationRepositoryProvider);
  return repo.aggregateDaily(range.start, range.end);
});

final dailyStepsProvider = FutureProvider.family<int, DateRange>((ref, range) async {
  final repo = ref.watch(activityRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  final entries = await repo.fetchByDateRange(range.start, range.end);
  return service.dailySteps(entries);
});

final calorieBurnEstimateProvider = FutureProvider.family<int, DateRange>((ref, range) async {
  final repo = ref.watch(activityRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  final entries = await repo.fetchByDateRange(range.start, range.end);
  return service.calorieBurnEstimate(entries);
});

final hydrationTotalProvider = FutureProvider.family<int, DateRange>((ref, range) async {
  final repo = ref.watch(hydrationRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  final entries = await repo.fetchByDateRange(range.start, range.end);
  return service.hydrationTotal(entries);
});

final sleepDurationProvider = FutureProvider.family<Duration, DateRange>((ref, range) async {
  final repo = ref.watch(vitalsRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  final entries = await repo.fetchByDateRange(range.start, range.end);
  return service.sleepDuration(entries);
});

final nutritionCaloriesProvider = FutureProvider.family<int, DateRange>((ref, range) async {
  final repo = ref.watch(nutritionRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  final entries = await repo.fetchByDateRange(range.start, range.end);
  return service.nutritionCalories(entries);
});

final netCalorieBalanceProvider = FutureProvider.family<int, DateRange>((ref, range) async {
  final activityRepo = ref.watch(activityRepositoryProvider);
  final nutritionRepo = ref.watch(nutritionRepositoryProvider);
  final service = ref.watch(healthAnalyticsServiceProvider);
  
  final activities = await activityRepo.fetchByDateRange(range.start, range.end);
  final nutrition = await nutritionRepo.fetchByDateRange(range.start, range.end);
  
  return service.netCalorieBalance(activities, nutrition);
});
