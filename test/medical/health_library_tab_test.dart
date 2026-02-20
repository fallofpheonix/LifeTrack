import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/core/ui/base_card.dart';
import 'package:lifetrack/domain/education/services/education_service.dart';
import 'package:lifetrack/features/medical/tabs/learn_tab.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

import '../fakes/fake_education_repository.dart';

void main() {
  testWidgets('LearnTab renders diseases', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          educationRepositoryProvider.overrideWithValue(FakeEducationRepository()),
          educationServiceProvider.overrideWithValue(
            EducationService(FakeEducationRepository()),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: LearnTab())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BaseCard), findsWidgets);
    expect(find.textContaining('Test Disease'), findsWidgets);
  });
}
