import 'package:flutter_test/flutter_test.dart';
import 'package:makankuy/main.dart';

void main() {
  testWidgets('MakanKuy app loads successfully', (tester) async {
    await tester.pumpWidget(const MakanKuyApp());
    expect(find.byType(MakanKuyApp), findsOneWidget);
  });
}