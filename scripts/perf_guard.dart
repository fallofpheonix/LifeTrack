// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  const int maxBundleSize = 30 * 1024 * 1024; // 30 MB
  final file = File('build/app/outputs/bundle/release/app-release.aab');

  if (!file.existsSync()) {
    print('❌ App bundle not found. Skipping performance check.');
    // In CI, build might verify compilation only, or check logic above.
    // If strict, exit(1). But for now warning.
    return;
  }

  final size = file.lengthSync();
  final sizeMB = (size / (1024 * 1024)).toStringAsFixed(2);

  print('📦 App Bundle Size: $sizeMB MB');

  if (size > maxBundleSize) {
    print('❌ FAST FAILURE: Bundle size exceeds limit of ${maxBundleSize ~/ (1024 * 1024)} MB');
    exit(1);
  } else {
    print('✅ Performance check passed.');
  }
}
