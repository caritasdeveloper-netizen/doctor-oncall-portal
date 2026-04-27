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

  Future<void> updateDepartment({
    required String id,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dept = Department(
        id: id,
        name: name,
      );
      await ref.read(departmentRepositoryProvider).updateDepartment(dept);
    });
  }

  Future<void> deleteDepartment(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(departmentRepositoryProvider).deleteDepartment(id);
    });
  }
}
