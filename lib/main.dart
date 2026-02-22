import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:lifetrack/core/theme/app_theme.dart';
import 'package:lifetrack/core/services/life_track_store.dart';
import 'package:lifetrack/core/state/store_provider.dart';
import 'package:lifetrack/core/storage/schema_service.dart';
import 'package:lifetrack/core/settings/ui_preferences.dart';
import 'package:lifetrack/core/ui/background/animated_health_background.dart';
import 'package:lifetrack/app/router/app_router.dart';
import 'package:lifetrack/data/repositories/local_vitals_repository.dart';
import 'package:lifetrack/data/repositories/local_medication_repository.dart';
import 'package:lifetrack/data/repositories/local_activity_repository.dart';
import 'package:lifetrack/data/repositories/local_meal_repository.dart';
import 'package:lifetrack/data/repositories/local_sleep_repository.dart';
import 'package:lifetrack/data/repositories/local_record_repository.dart';
import 'package:lifetrack/core/services/global_error_handler.dart';
import 'package:lifetrack/core/services/health_log.dart';
import 'package:lifetrack/core/services/data_governance_service.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // 1. Framework Errors (Widget tree)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      HealthLog.e('Main', 'FlutterError', 'Framework Error', error: details.exception, stackTrace: details.stack);
    };

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Initialize Infrastructure
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await UiPreferences.init(); // Load settings
    await SchemaService.init(); // Run migrations

    // Initialize Repositories
    final LocalVitalsRepository vitalsRepo = LocalVitalsRepository(prefs);
    final LocalMedicationRepository medicationRepo = LocalMedicationRepository(prefs);
    final LocalActivityRepository activityRepo = LocalActivityRepository(prefs);
    final LocalMealRepository mealRepo = LocalMealRepository(prefs);
    final LocalSleepRepository sleepRepo = LocalSleepRepository(prefs);
    final LocalRecordRepository recordRepo = LocalRecordRepository(prefs);

    // Data Governance
    final DataGovernanceService governanceService = DataGovernanceService();
    
    // Education Layer
    final EducationRepository educationRepo = EducationRepositoryImpl();

    // Load Store with Repositories
    final LifeTrackStore store = await LifeTrackStore.load(
      vitalsRepo, 
      medicationRepo,
      activityRepo,
      mealRepo,
      sleepRepo,
      recordRepo,
      educationRepo,
      governanceService,
    );

    runApp(
      ProviderScope(
        overrides: [
          lifeTrackStoreProvider.overrideWithValue(store),
        ],
        child: const LifeTrackApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    GlobalErrorHandler.handleAsyncError(error, stack);
  });
}

class LifeTrackApp extends ConsumerWidget {
  const LifeTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(lifeTrackStoreProvider).themeMode;
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          const AnimatedHealthBackground(), // Global background layer
          MaterialApp(
            title: 'LifeTrack',
            theme: AppTheme.lightTheme.copyWith(
               scaffoldBackgroundColor: Colors.transparent, // Crucial for background visibility
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
               scaffoldBackgroundColor: Colors.transparent, // Crucial for background visibility
            ),
            themeMode: themeMode,
            routes: AppRouter.routes,
            initialRoute: AppRoutes.root,
            debugShowCheckedModeBanner: false,
          ),
        ],
      ),
    );
  }
}
