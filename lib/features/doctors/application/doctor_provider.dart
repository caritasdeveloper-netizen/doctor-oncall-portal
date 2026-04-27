import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/doctors/infrastructure/firebase_doctor_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'doctor_provider.g.dart';

@riverpod
Stream<List<Doctor>> doctors(Ref ref) {
  return ref.watch(doctorRepositoryProvider).watchDoctors();
}

@riverpod
class DoctorController extends _$DoctorController {
  @override
  FutureOr<void> build() {}

  Future<void> createDoctor({
    required String employeeId,
    required String name,
    required String phoneNumber,
    required List<String> departmentIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final doctor = Doctor(
        id: '', // Firestore will generate
        employeeId: employeeId,
        name: name,
        phoneNumber: phoneNumber,
        departmentIds: departmentIds,
      );
      await ref.read(doctorRepositoryProvider).createDoctor(doctor);
    });
  }

  Future<void> updateDoctor({
    required String id,
    required String employeeId,
    required String name,
    required String phoneNumber,
    required List<String> departmentIds,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final doctor = Doctor(
        id: id,
        employeeId: employeeId,
        name: name,
        phoneNumber: phoneNumber,
        departmentIds: departmentIds,
      );
      await ref.read(doctorRepositoryProvider).updateDoctor(doctor);
    });
  }

  Future<void> deleteDoctor(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(doctorRepositoryProvider).deleteDoctor(id);
    });
  }
}
