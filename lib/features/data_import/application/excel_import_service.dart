import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:oncall_doctor/features/data_import/domain/excel_import_row.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';

class ExcelImportService {
  static const List<String> requiredColumns = [
    'Doctor Name',
    'Employee ID',
    'Phone Number',
    'Department'
  ];

  /// Parses Excel bytes and returns a list of rows with validation results.
  List<ExcelImportRow> parseExcel(Uint8List bytes, List<Doctor> existingDoctors) {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null || sheet.maxRows == 0) {
      throw Exception('The Excel file is empty.');
    }

    // 1. Column Validation
    final headers = sheet.rows.first.map((cell) => cell?.value?.toString().trim() ?? '').toList();
    
    _validateHeaders(headers);

    final List<ExcelImportRow> rows = [];
    final Set<String> seenEmployeeIds = {};

    // 2. Data Parsing & Row Validation
    for (int i = 1; i < sheet.maxRows; i++) {
      final rowData = sheet.rows[i];
      if (rowData.isEmpty || rowData.every((cell) => cell == null || cell.value == null)) continue;

      final doctorName = rowData[headers.indexOf('Doctor Name')]?.value?.toString().trim() ?? '';
      final employeeId = rowData[headers.indexOf('Employee ID')]?.value?.toString().trim() ?? '';
      final phoneNumber = rowData[headers.indexOf('Phone Number')]?.value?.toString().trim() ?? '';
      final department = rowData[headers.indexOf('Department')]?.value?.toString().trim() ?? '';

      final List<String> errors = [];

      if (doctorName.isEmpty) errors.add('Doctor Name is required');
      if (employeeId.isEmpty) errors.add('Employee ID is required');
      if (phoneNumber.isEmpty) errors.add('Phone Number is required');
      if (department.isEmpty) errors.add('Department is required');

      // Unique Employee ID check within the file
      bool isDuplicateInFile = false;
      if (employeeId.isNotEmpty) {
        if (seenEmployeeIds.contains(employeeId)) {
          errors.add('Duplicate Employee ID in file');
          isDuplicateInFile = true;
        } else {
          seenEmployeeIds.add(employeeId);
        }
      }

      // Check if exists in system
      final bool existsInSystem = existingDoctors.any((d) => d.employeeId == employeeId);

      rows.add(ExcelImportRow(
        doctorName: doctorName,
        employeeId: employeeId,
        phoneNumber: phoneNumber,
        department: department,
        errors: errors,
        isDuplicate: isDuplicateInFile,
        existsInSystem: existsInSystem,
      ));
    }

    return rows;
  }

  void _validateHeaders(List<String> headers) {
    final missing = requiredColumns.where((col) => !headers.contains(col)).toList();
    final extra = headers.where((col) => !requiredColumns.contains(col) && col.isNotEmpty).toList();

    if (missing.isNotEmpty || extra.isNotEmpty) {
      String message = '';
      if (missing.isNotEmpty) message += 'Missing columns: ${missing.join(", ")}. ';
      if (extra.isNotEmpty) message += 'Extra columns: ${extra.join(", ")}. ';
      message += 'Column names must match exactly: ${requiredColumns.join(", ")}';
      throw Exception(message);
    }
  }

  /// Generates the Excel template bytes.
  Uint8List generateTemplate() {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    
    // Add headers
    for (int i = 0; i < requiredColumns.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = TextCellValue(requiredColumns[i]);
    }

    // Add a sample row
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value = TextCellValue('Dr. John Doe');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value = TextCellValue('EMP001');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value = TextCellValue('1234567890');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 1)).value = TextCellValue('Cardiology');

    final bytes = excel.encode();
    return Uint8List.fromList(bytes!);
  }
}
