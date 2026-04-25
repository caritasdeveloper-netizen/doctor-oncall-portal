import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/departments/infrastructure/firebase_department_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_controller.g.dart';

@riverpod
class DepartmentController extends _$DepartmentController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> createDepartment({
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dept = Department(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Simplified ID generation
        name: name,
      );
      await ref.read(departmentRepositoryProvider).createDepartment(dept);
    });
  }
}
