import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lifetrack/core/services/life_track_store.dart';

void main() {
  testWidgets('LifeTrack shell renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    // We need to initialize the store. Since Pedometer might cause issues in test,
    // we rely on the try-catch in _initPedometer or mock it. 
    // Ideally we should mock the store, but for integration test we use real one with mocked prefs.
    final LifeTrackStore store = await LifeTrackStore.load();

    await tester.pumpWidget(LifeTrackApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('LifeTrack'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
