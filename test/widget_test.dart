import 'package:flutter_test/flutter_test.dart';
import 'package:lifetrack/main.dart';

void main() {
  testWidgets('LifeTrack shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeTrackApp());

    expect(find.text('LifeTrack'), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
