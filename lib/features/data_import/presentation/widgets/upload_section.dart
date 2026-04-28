import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_provider.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';

class UploadSection extends ConsumerStatefulWidget {
  const UploadSection({super.key});

  @override
  ConsumerState<UploadSection> createState() => _UploadSectionState();
}

class _UploadSectionState extends ConsumerState<UploadSection> {
  DropzoneViewController? controller;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Excel File',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(minHeight: 200),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isHighlighted ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHighlighted ? AppTheme.primaryColor : AppTheme.borderColor.withOpacity(0.5),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Stack(
            children: [
              if (kIsWeb)
                Positioned.fill(
                  child: DropzoneView(
                    operation: DragOperation.copy,
                    cursor: CursorType.Default,
                    onCreated: (ctrl) => controller = ctrl,
                    onHover: () => setState(() => isHighlighted = true),
                    onLeave: () => setState(() => isHighlighted = false),
                    onDrop: (file) async {
                      setState(() => isHighlighted = false);
                      final bytes = await controller!.getFileData(file);
                      ref.read(excelImportProvider.notifier).uploadFile(bytes);
                    },
                  ),
                ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 56,
                            color: isHighlighted ? AppTheme.primaryColor : AppTheme.textSecondaryColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            kIsWeb ? 'Drag and drop your Excel file here' : 'Upload your Excel file',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (kIsWeb)
                            Text(
                              'or',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _pickFile,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Browse Files',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    IgnorePointer(
                      child: Text(
                        'Accepted formats: .xlsx, .xls',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await fp.FilePicker.pickFiles(
      type: fp.FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      ref.read(excelImportProvider.notifier).uploadFile(result.files.single.bytes!);
    }
  }
}
