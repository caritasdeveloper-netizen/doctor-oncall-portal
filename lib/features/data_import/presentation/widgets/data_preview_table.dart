import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_provider.dart';
import 'package:oncall_doctor/features/data_import/domain/excel_import_row.dart';

class DataPreviewTable extends ConsumerWidget {
  const DataPreviewTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excelImportProvider);
    final rows = state.rows;

    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Data Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildSummary(rows),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(Colors.grey[50]),
                columns: const [
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Doctor Name')),
                  DataColumn(label: Text('Employee ID')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Issues')),
                ],
                rows: rows.map((row) => _buildDataRow(row)).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummary(List<ExcelImportRow> rows) {
    final total = rows.length;
    final valid = rows.where((r) => r.isValid).length;
    final failed = total - valid;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildSummaryItem('Total: $total', Colors.grey[700]!),
        _buildSummaryItem('Valid: $valid', Colors.green[700]!),
        _buildSummaryItem('Errors: $failed', Colors.red[700]!),
      ],
    );
  }

  Widget _buildSummaryItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  DataRow _buildDataRow(ExcelImportRow row) {
    final isValid = row.isValid;
    final color = isValid ? null : WidgetStateProperty.all(Colors.red.withOpacity(0.02));

    return DataRow(
      color: color,
      cells: [
        DataCell(
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green : Colors.red,
            size: 20,
          ),
        ),
        DataCell(Text(row.doctorName, style: _cellStyle(isValid))),
        DataCell(Text(row.employeeId, style: _cellStyle(isValid))),
        DataCell(Text(row.phoneNumber, style: _cellStyle(isValid))),
        DataCell(Text(row.department, style: _cellStyle(isValid))),
        DataCell(
          row.errors.isEmpty
              ? (row.existsInSystem ? const Text('Exist - Will Update', style: TextStyle(color: Colors.blue, fontSize: 12)) : const Text('New Record', style: TextStyle(color: Colors.green, fontSize: 12)))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: row.errors.map((e) => Text(e, style: const TextStyle(color: Colors.red, fontSize: 11))).toList(),
                ),
        ),
      ],
    );
  }

  TextStyle _cellStyle(bool isValid) {
    return TextStyle(
      color: isValid ? Colors.black87 : Colors.red[900],
      fontSize: 13,
    );
  }
}
