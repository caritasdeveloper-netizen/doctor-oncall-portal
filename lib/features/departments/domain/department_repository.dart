import 'package:oncall_doctor/features/departments/domain/department.dart';

abstract class DepartmentRepository {
  Stream<List<Department>> watchDepartments();
  Future<void> createDepartment(Department department);
}
