import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufm/app/app.dart';
import 'package:ufm/core/database/database_provider.dart';
import 'unit/database/in_memory_database.dart';

void main() {
  testWidgets('App smoke test - verifies navigation shell renders', (tester) async {
    final db = createTestDatabase();
    addTearDown(() async => db.close());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const UfmApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('UFM'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Accounts'), findsWidgets);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}
