// Basic smoke test: verify the app starts without crashing.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resource_admin/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AdminApp()));
    // Just verify the app builds without throwing.
  });
}
