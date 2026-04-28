import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:oncall_doctor/features/data_import/domain/excel_import_row.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';

class ExcelImportService {
  static const Map<String, List<String>> headerAliases = {
    'Doctor Name': ['doctor name', 'name', 'dr name', 'doctor'],
    'Employee ID': ['employee id', 'emp id', 'id', 'employeeid', 'empid', 'staff id'],
    'Phone Number': ['phone number', 'phone', 'contact', 'mobile', 'mobile number', 'phone no'],
    'Department': ['department', 'dept'],
  };

  /// Parses Excel bytes and returns a list of rows with validation results.
  List<ExcelImportRow> parseExcel(Uint8List bytes, List<Doctor> existingDoctors) {
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first];
    if (sheet == null || sheet.maxRows == 0) {
      throw Exception('The Excel file is empty.');
    }

    // 1. Column Validation & Mapping
    final rawHeaders = sheet.rows.first.map((cell) => cell?.value?.toString().trim().toLowerCase() ?? '').toList();
    
    final Map<String, int> columnIndices = {};
    final List<String> missingColumns = [];

    headerAliases.forEach((requiredCol, aliases) {
      int index = -1;
      for (var alias in aliases) {
        index = rawHeaders.indexOf(alias.toLowerCase());
        if (index != -1) break;
      }
      
      if (index != -1) {
        columnIndices[requiredCol] = index;
      } else {
        missingColumns.add(requiredCol);
      }
    });

    if (missingColumns.isNotEmpty) {
      throw Exception('Missing required columns: ${missingColumns.join(", ")}. Please ensure your Excel file has these headers.');
    }

    final List<ExcelImportRow> rows = [];
    final Set<String> seenEmployeeIds = {};

    // 2. Data Parsing & Row Validation
    for (int i = 1; i < sheet.maxRows; i++) {
      final rowData = sheet.rows[i];
      if (rowData.isEmpty || rowData.every((cell) => cell == null || cell.value == null)) continue;

      final doctorName = _getCellValue(rowData, columnIndices['Doctor Name']!);
      final employeeId = _getCellValue(rowData, columnIndices['Employee ID']!);
      final phoneNumber = _getCellValue(rowData, columnIndices['Phone Number']!);
      final department = _getCellValue(rowData, columnIndices['Department']!);

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

  String _getCellValue(List<Data?> row, int index) {
    if (index >= row.length) return '';
    return row[index]?.value?.toString().trim() ?? '';
  }

  static const List<String> requiredColumns = [
    'Doctor Name',
    'Employee ID',
    'Phone Number',
    'Department'
  ];

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
