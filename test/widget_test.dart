import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/app/app.dart';

void main() {
  testWidgets('App smoke test - verifies navigation shell renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: UfmApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('UFM Dashboard'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Accounts'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
  });
}
