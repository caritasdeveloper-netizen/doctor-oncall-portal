import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/departments/infrastructure/firebase_department_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'department_provider.g.dart';

@riverpod
Stream<List<Department>> departments(Ref ref) {
  return ref.watch(departmentRepositoryProvider).watchDepartments();
}
