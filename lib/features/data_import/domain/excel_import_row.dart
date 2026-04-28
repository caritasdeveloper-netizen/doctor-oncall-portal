import 'package:freezed_annotation/freezed_annotation.dart';

part 'excel_import_row.freezed.dart';

@freezed
abstract class ExcelImportRow with _$ExcelImportRow {
  const factory ExcelImportRow({
    required String doctorName,
    required String employeeId,
    required String phoneNumber,
    required String department,
    @Default([]) List<String> errors,
    @Default(false) bool isDuplicate,
    @Default(false) bool existsInSystem,
  }) = _ExcelImportRow;

  const ExcelImportRow._();

  bool get isValid => errors.isEmpty;
}
