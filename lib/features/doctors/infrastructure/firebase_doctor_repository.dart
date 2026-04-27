import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/core/infrastructure/firebase_providers.dart';

part 'firebase_doctor_repository.g.dart';

class FirebaseDoctorRepository implements DoctorRepository {
  final FirebaseFirestore _firestore;

  FirebaseDoctorRepository(this._firestore);

  @override
  Stream<List<Doctor>> watchDoctors() {
    return _firestore.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Doctor.fromJson({...doc.data(), 'id': doc.id})).toList();
    });
  }

  @override
  Future<void> createDoctor(Doctor doctor) async {
    await _firestore.collection('doctors').add(doctor.toJson());
  }

  @override
  Future<void> updateDoctor(Doctor doctor) async {
    await _firestore.collection('doctors').doc(doctor.id).update(doctor.toJson());
  }

  @override
  Future<void> deleteDoctor(String id) async {
    await _firestore.collection('doctors').doc(id).delete();
  }

  @override
  Future<Doctor?> getDoctorById(String id) async {
    final doc = await _firestore.collection('doctors').doc(id).get();
    if (!doc.exists) return null;
    return Doctor.fromJson({...doc.data()!, 'id': doc.id});
  }
}

@riverpod
DoctorRepository doctorRepository(Ref ref) {
  return FirebaseDoctorRepository(ref.watch(firestoreProvider));
}
