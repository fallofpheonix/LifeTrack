import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/design_system/components/glass_card.dart';
import 'package:lifetrack/domain/education/services/education_service.dart';
import 'package:lifetrack/features/medical/ui/tabs/library_tab.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

import '../fakes/fake_education_repository.dart';

void main() {
  testWidgets('LibraryTab renders diseases', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          educationRepositoryProvider.overrideWithValue(FakeEducationRepository()),
          educationServiceProvider.overrideWithValue(
            EducationService(FakeEducationRepository()),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: LibraryTab())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(GlassCard), findsWidgets);
    expect(find.textContaining('Test Disease'), findsWidgets);
  });
}
