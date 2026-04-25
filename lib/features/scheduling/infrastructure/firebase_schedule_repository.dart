import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule.dart';
import 'package:oncall_doctor/features/scheduling/domain/schedule_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/core/infrastructure/firebase_providers.dart';

part 'firebase_schedule_repository.g.dart';

class FirebaseScheduleRepository implements ScheduleRepository {
  final FirebaseFirestore _firestore;

  FirebaseScheduleRepository(this._firestore);

  @override
  Stream<List<DailySchedule>> watchSchedules(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection('schedules')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Convert Timestamp to DateTime for JSON deserialization if needed
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate().toIso8601String();
        }
        return DailySchedule.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  @override
  Future<void> saveSchedules(List<DailySchedule> schedules) async {
    final batch = _firestore.batch();
    for (final schedule in schedules) {
      // Use departmentId_date as ID to avoid duplicates for same day/dept
      final dateStr = "${schedule.date.year}${schedule.date.month.toString().padLeft(2, '0')}${schedule.date.day.toString().padLeft(2, '0')}";
      final id = "${schedule.departmentId}_$dateStr";
      final docRef = _firestore.collection('schedules').doc(id);
      
      final data = schedule.toJson();
      data['date'] = Timestamp.fromDate(schedule.date);
      
      batch.set(docRef, data);
    }
    await batch.commit();
  }

  @override
  Future<void> applyBulkAssignment(BulkAssignmentRequest request) async {
    final batch = _firestore.batch();
    for (final date in request.dates) {
      for (final deptId in request.departmentIds) {
        final dateStr = "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
        final id = "${deptId}_$dateStr";
        final docRef = _firestore.collection('schedules').doc(id);
        
        final data = {
          'date': Timestamp.fromDate(date),
          'departmentId': deptId,
          'firstOnCallDoctorIds': request.firstOnCallDoctorIds,
          'secondOnCallDoctorIds': request.secondOnCallDoctorIds,
        };
        
        batch.set(docRef, data);
      }
    }
    await batch.commit();
  }
}

@riverpod
ScheduleRepository scheduleRepository(Ref ref) {
  return FirebaseScheduleRepository(ref.watch(firestoreProvider));
}
