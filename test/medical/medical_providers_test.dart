import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifetrack/domain/education/services/education_service.dart';
import 'package:lifetrack/presentation/medical/providers/medical_providers.dart';

import '../fakes/fake_education_repository.dart';

void main() {
  test('rotatingDiseaseProvider returns 5 diseases', () async {
    final container = ProviderContainer(overrides: <Override>[
      educationRepositoryProvider.overrideWithValue(FakeEducationRepository()),
      educationServiceProvider.overrideWithValue(
        EducationService(FakeEducationRepository()),
      ),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(rotatingDiseaseProvider.future);

    expect(result.length, 5);
    expect(
      result.map((d) => d.name).toSet(),
      containsAll(<String>{
        'Test Disease A',
        'Test Disease B',
        'Test Disease C',
        'Test Disease D',
        'Test Disease E',
      }),
    );
  });

  test('didYouKnowProvider returns fake fact', () async {
    final container = ProviderContainer(overrides: <Override>[
      educationRepositoryProvider.overrideWithValue(FakeEducationRepository()),
      educationServiceProvider.overrideWithValue(
        EducationService(FakeEducationRepository()),
      ),
    ]);
    addTearDown(container.dispose);

    final result = await container.read(didYouKnowProvider.future);
    expect(result, 'Mock Fact');
  });
}
