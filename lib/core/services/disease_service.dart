import 'package:lifetrack/domain/education/models/disease.dart';
import 'package:lifetrack/domain/education/repositories/education_repository.dart';

class DiseaseService {
  final EducationRepository _educationRepo;

  DiseaseService(this._educationRepo);

  Future<Disease?> fetchDiseaseLocal(String query) async {
    try {
      final diseases = await _educationRepo.loadDiseases();
      final q = query.toLowerCase();
      
      // Find exact or partial match
      return diseases.firstWhere(
        (d) => d.name.toLowerCase().contains(q),
        orElse: () => diseases.first, // Fallback to first one or handle differently
      );
    } catch (e) {
      return null;
    }
  }
}
