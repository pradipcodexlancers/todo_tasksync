import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:todo_tasksync/core/constants/app_strings.dart';
import 'package:todo_tasksync/main.dart';
import 'package:todo_tasksync/services/storage_service.dart';

void main() {
  setUp(() async {
    Get.reset();
    await Get.putAsync<StorageService>(() => StorageService().init());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('My Tasks screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify header and button exist
    expect(find.text(AppStrings.myTasks), findsOneWidget);
    expect(find.text(AppStrings.addTask), findsOneWidget);
  });
}
