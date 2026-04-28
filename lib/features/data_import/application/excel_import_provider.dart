import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_service.dart';
import 'package:oncall_doctor/features/data_import/domain/excel_import_row.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/doctors/infrastructure/firebase_doctor_repository.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';
import 'package:oncall_doctor/features/departments/infrastructure/firebase_department_repository.dart';
import 'package:uuid/uuid.dart';

part 'excel_import_provider.g.dart';

enum ImportUpdateRule { update, skip }

class ExcelImportState {
  final List<ExcelImportRow> rows;
  final bool isLoading;
  final String? errorMessage;
  final ImportUpdateRule updateRule;
  final List<String> newDepartments;
  final bool isProcessing;

  ExcelImportState({
    this.rows = const [],
    this.isLoading = false,
    this.errorMessage,
    this.updateRule = ImportUpdateRule.update,
    this.newDepartments = const [],
    this.isProcessing = false,
  });

  ExcelImportState copyWith({
    List<ExcelImportRow>? rows,
    bool? isLoading,
    String? errorMessage,
    ImportUpdateRule? updateRule,
    List<String>? newDepartments,
    bool? isProcessing,
  }) {
    return ExcelImportState(
      rows: rows ?? this.rows,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      updateRule: updateRule ?? this.updateRule,
      newDepartments: newDepartments ?? this.newDepartments,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

@riverpod
class ExcelImportNotifier extends _$ExcelImportNotifier {
  @override
  ExcelImportState build() {
    return ExcelImportState();
  }

  final _service = ExcelImportService();

  void setUpdateRule(ImportUpdateRule rule) {
    state = state.copyWith(updateRule: rule);
  }

  Future<void> uploadFile(Uint8List bytes) async {
    state = state.copyWith(isLoading: true, errorMessage: null, rows: []);
    try {
      final doctorsAsync = ref.read(doctorRepositoryProvider).watchDoctors().first;
      final existingDoctors = await doctorsAsync;
      
      final rows = _service.parseExcel(bytes, existingDoctors);
      
      // Identify new departments
      final departmentsAsync = ref.read(departmentRepositoryProvider).watchDepartments().first;
      final existingDepartments = await departmentsAsync;
      final existingDeptNames = existingDepartments.map((d) => d.name.toLowerCase()).toSet();
      
      final List<String> newDepts = [];
      for (final row in rows) {
        if (row.department.isNotEmpty && !existingDeptNames.contains(row.department.toLowerCase())) {
          if (!newDepts.contains(row.department)) {
            newDepts.add(row.department);
          }
        }
      }

      state = state.copyWith(
        rows: rows,
        isLoading: false,
        newDepartments: newDepts,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> processImport() async {
    if (state.rows.isEmpty) return;

    state = state.copyWith(isProcessing: true);
    try {
      final doctorRepo = ref.read(doctorRepositoryProvider);
      final departmentRepo = ref.read(departmentRepositoryProvider);
      
      // 1. Create missing departments first
      final existingDepartments = await departmentRepo.watchDepartments().first;
      final Map<String, String> deptNameToId = {
        for (var d in existingDepartments) d.name.toLowerCase(): d.id
      };

      for (final deptName in state.newDepartments) {
        final newId = Uuid().v4();
        await departmentRepo.createDepartment(Department(id: newId, name: deptName));
        // Note: In a real app, you might want to wait for the sync or get the generated ID if not providing one.
        // Since we are using Firebase, if we don't provide an ID, we get it back. 
        // Our repo's createDepartment adds a new doc. Let's assume we can fetch them again or wait.
      }
      
      // Refresh departments map after creation
      final updatedDepartments = await departmentRepo.watchDepartments().first;
      final Map<String, String> finalDeptMap = {
        for (var d in updatedDepartments) d.name.toLowerCase(): d.id
      };

      // 2. Process Doctors
      final existingDoctors = await doctorRepo.watchDoctors().first;

      for (final row in state.rows) {
        if (!row.isValid) continue;

        final deptId = finalDeptMap[row.department.toLowerCase()];
        if (deptId == null) continue; // Should not happen

        final existingDoctor = existingDoctors.cast<Doctor?>().firstWhere(
          (d) => d?.employeeId == row.employeeId,
          orElse: () => null,
        );

        if (existingDoctor == null) {
          // Add new
          await doctorRepo.createDoctor(Doctor(
            id: '', // Firebase will generate
            employeeId: row.employeeId,
            name: row.doctorName,
            phoneNumber: row.phoneNumber,
            departmentIds: [deptId],
          ));
        } else if (state.updateRule == ImportUpdateRule.update) {
          // Update existing
          await doctorRepo.updateDoctor(existingDoctor.copyWith(
            name: row.doctorName,
            phoneNumber: row.phoneNumber,
            departmentIds: [deptId],
          ));
        }
      }

      state = state.copyWith(isProcessing: false, rows: [], newDepartments: []);
    } catch (e) {
      state = state.copyWith(isProcessing: false, errorMessage: 'Failed to process import: $e');
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
