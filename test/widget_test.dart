import 'package:flutter_test/flutter_test.dart';
import 'package:gift_nest/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('GiftNestApp smoke test renders Splash Screen branding', (WidgetTester tester) async {
    await tester.pumpWidget(const GiftNestApp());

    // Verify initial Splash screen branding is rendered
    expect(find.text('Gift Nest'), findsOneWidget);
    expect(find.text('Thoughtful gifts, made personal.'), findsOneWidget);

    // Pump past the splash timer and settle onto Onboarding
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    expect(find.text("Find a gift they'll love"), findsOneWidget);
  });
}
