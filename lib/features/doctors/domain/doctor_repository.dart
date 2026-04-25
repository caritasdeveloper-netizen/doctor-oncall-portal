import 'package:oncall_doctor/features/doctors/domain/doctor.dart';

abstract class DoctorRepository {
  Stream<List<Doctor>> watchDoctors();
  Future<void> createDoctor(Doctor doctor);
  Future<Doctor?> getDoctorById(String id);
}
