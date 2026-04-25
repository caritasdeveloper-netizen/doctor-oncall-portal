import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/departments/domain/department_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/core/infrastructure/firebase_providers.dart';

part 'firebase_department_repository.g.dart';

class FirebaseDepartmentRepository implements DepartmentRepository {
  final FirebaseFirestore _firestore;

  FirebaseDepartmentRepository(this._firestore);

  @override
  Stream<List<Department>> watchDepartments() {
    return _firestore.collection('departments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Department.fromJson({...doc.data(), 'id': doc.id})).toList();
    });
  }

  @override
  Future<void> createDepartment(Department department) async {
    await _firestore.collection('departments').add(department.toJson());
  }
}

@riverpod
DepartmentRepository departmentRepository(Ref ref) {
  return FirebaseDepartmentRepository(ref.watch(firestoreProvider));
}
