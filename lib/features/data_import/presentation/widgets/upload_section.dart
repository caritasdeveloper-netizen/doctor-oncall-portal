import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oncall_doctor/features/data_import/application/excel_import_provider.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

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
        const Text(
          'Upload Excel File',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          constraints: const BoxConstraints(minHeight: 200),
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.blue.withOpacity(0.05) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlighted ? Colors.blue : Colors.grey[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Stack(
            children: [
              if (kIsWeb)
                DropzoneView(
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
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: isHighlighted ? Colors.blue : Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      kIsWeb ? 'Drag and drop your Excel file here' : 'Upload your Excel file',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (kIsWeb)
                      const Text(
                        'or',
                        style: TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _pickFile,
                      child: const Text('Browse Files', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Accepted formats: .xlsx, .xls',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
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
