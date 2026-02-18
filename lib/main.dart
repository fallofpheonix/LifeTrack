import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'core/theme/app_theme.dart';
import 'core/services/life_track_store.dart';
import 'core/storage/schema_service.dart';
import 'core/settings/ui_preferences.dart';
import 'core/ui/background/animated_health_background.dart';
import 'features/dashboard/home_page.dart';
import 'data/repositories/local_vitals_repository.dart';
import 'data/repositories/local_medication_repository.dart';
import 'data/repositories/mock_auth_repository.dart';
import 'core/data/repository/auth_repository.dart';
import 'core/data/local/local_token_store.dart';
import 'core/services/user_session_service.dart';
import 'core/services/global_error_handler.dart';
import 'core/services/health_log.dart';

import 'core/services/key_manager.dart';
import 'core/services/encryption_service.dart';
import 'core/services/secure_serializer.dart';
import 'core/services/sync_queue_service.dart';
import 'core/services/mock_backend.dart';
import 'core/services/sync_service.dart';
import 'core/services/data_governance_service.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // 1. Framework Errors (Widget tree)
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      HealthLog.e('Main', 'FlutterError', 'Framework Error', error: details.exception, stackTrace: details.stack);
    };

    // 2. Platform/Engine Errors
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      HealthLog.e('Main', 'PlatformError', 'Uncaught Platform Error', error: error, stackTrace: stack);
      return true; // Handled
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

    // Encryption Layer
    final KeyManager keyManager = KeyManager();
    final EncryptionService encryptionService = EncryptionService(keyManager);
    final SecureSerializer secureSerializer = SecureSerializer(encryptionService);

    // Sync Layer
    final SyncQueueService syncQueue = SyncQueueService(prefs);
    final MockBackend backend = MockBackend();
    final SyncService syncService = SyncService(syncQueue, backend);
    syncService.startSyncLoop();

    // Identity Layer
    final LocalTokenStore tokenStore = LocalTokenStore();
    final AuthRepository authRepo = MockAuthRepository(tokenStore: tokenStore);
    final UserSessionService sessionService = UserSessionService(
      authRepository: authRepo,
      tokenStore: tokenStore,
    );

    // Data Governance
    final DataGovernanceService governanceService = DataGovernanceService();

    // Load Store with Repositories
    final LifeTrackStore store = await LifeTrackStore.load(
      vitalsRepo, 
      medicationRepo,
      sessionService,
      secureSerializer,
      syncQueue,
      syncService,
      governanceService,
    );

    runApp(
      ChangeNotifierProvider<LifeTrackStore>(
        create: (BuildContext context) => store,
        child: const LifeTrackApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    GlobalErrorHandler.handleAsyncError(error, stack);
  });
}

class LifeTrackApp extends StatelessWidget {
  const LifeTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final LifeTrackStore store = Provider.of<LifeTrackStore>(context);
    
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          const AnimatedHealthBackground(), // Global background layer
          MaterialApp(
            title: 'LifeTrack',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1D8A6F),
                brightness: Brightness.light, 
              ),
              scaffoldBackgroundColor: Colors.transparent, // Crucial for background visibility
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                titleTextStyle: TextStyle(
                  color: Color(0xFF191C1E),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                iconTheme: IconThemeData(color: Color(0xFF191C1E)),
              ),
               // We can keep text theme defaults or override as needed
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
               scaffoldBackgroundColor: Colors.transparent, // Crucial for background visibility
            ),
            themeMode: store.themeMode,
            home: LifeTrackHomePage(store: store),
            debugShowCheckedModeBanner: false,
          ),
        ],
      ),
    );
  }
}
