import 'package:oncall_doctor/features/doctors/domain/doctor.dart';

abstract class DoctorRepository {
  Stream<List<Doctor>> watchDoctors();
  Future<void> createDoctor(Doctor doctor);
  Future<void> updateDoctor(Doctor doctor);
  Future<void> deleteDoctor(String id);
  Future<Doctor?> getDoctorById(String id);
}
