import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_provider.dart';
import 'package:oncall_doctor/features/data_import/presentation/widgets/upload_section.dart';
import 'package:oncall_doctor/features/data_import/presentation/widgets/data_preview_table.dart';
import 'package:oncall_doctor/features/data_import/presentation/widgets/new_departments_dialog.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_service.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart' as fp;

class ExcelUploadPage extends ConsumerWidget {
  const ExcelUploadPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(excelImportProvider);
    final notifier = ref.read(excelImportProvider.notifier);
    
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.backgroundColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildMainCard(context, ref, state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload Data from Excel',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Import or update doctor records using an Excel file.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _downloadTemplate,
          icon: const Icon(Icons.download, size: 20),
          label: const Text('Download Template'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.primaryColor,
            elevation: 0,
            minimumSize: const Size(200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppTheme.borderColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(BuildContext context, WidgetRef ref, ExcelImportState state, ExcelImportNotifier notifier) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UploadSection(),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (state.rows.isNotEmpty) ...[
            const DataPreviewTable(),
            const SizedBox(height: 32),
            _buildActionSection(context, ref, state, notifier),
          ],
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, WidgetRef ref, ExcelImportState state, ExcelImportNotifier notifier) {
    final validCount = state.rows.where((r) => r.isValid).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 24,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Rule for Existing Doctors',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose how to handle records where the Employee ID already exists in the system.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SegmentedButton<ImportUpdateRule>(
            segments: const [
              ButtonSegment(
                value: ImportUpdateRule.update,
                label: Text('Update'),
                icon: Icon(Icons.sync),
              ),
              ButtonSegment(
                value: ImportUpdateRule.skip,
                label: Text('Skip'),
                icon: Icon(Icons.skip_next),
              ),
            ],
            selected: {state.updateRule},
            onSelectionChanged: (value) => notifier.setUpdateRule(value.first),
          ),
          ElevatedButton(
            onPressed: state.isProcessing || validCount == 0 ? null : () => _handleProcess(context, state, notifier),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: state.isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Update Doctors', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _handleProcess(BuildContext context, ExcelImportState state, ExcelImportNotifier notifier) {
    if (state.newDepartments.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => NewDepartmentsDialog(
          departments: state.newDepartments,
          onConfirm: () => _finalProcess(context, notifier),
        ),
      );
    } else {
      _finalProcess(context, notifier);
    }
  }

  Future<void> _finalProcess(BuildContext context, ExcelImportNotifier notifier) async {
    await notifier.processImport();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Import completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _downloadTemplate() async {
    try {
      final service = ExcelImportService();
      final bytes = service.generateTemplate();
      
      if (kIsWeb) {
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "doctor_upload_template.xlsx")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For mobile/desktop, use file_picker to save the file
        final result = await fp.FilePicker.platform.saveFile(
          fileName: "doctor_upload_template.xlsx",
          bytes: bytes,
          type: fp.FileType.custom,
          allowedExtensions: ['xlsx'],
        );
        
        if (result != null) {
          debugPrint('Template saved to: $result');
        }
      }
    } catch (e) {
      debugPrint('Template download error: $e');
    }
  }
}
