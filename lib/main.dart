import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/services/life_track_store.dart';
import 'features/dashboard/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final LifeTrackStore store = await LifeTrackStore.load();
  runApp(LifeTrackApp(store: store));
}

class LifeTrackApp extends StatelessWidget {
  const LifeTrackApp({super.key, required this.store});

  final LifeTrackStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTrack',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8A6F)),
        scaffoldBackgroundColor: const Color(0xFFF5F8F7),

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
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF191C1E)),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF191C1E)),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF191C1E)),
        ),
      ),
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: LifeTrackHomePage(store: store),
      debugShowCheckedModeBanner: false,
    );
  }
}
