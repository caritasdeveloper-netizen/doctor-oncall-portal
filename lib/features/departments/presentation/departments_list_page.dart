import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/departments/application/department_controller.dart';
import 'package:oncall_doctor/features/departments/application/department_provider.dart';
import 'package:oncall_doctor/features/departments/domain/department.dart';

class DepartmentsListPage extends ConsumerStatefulWidget {
  const DepartmentsListPage({super.key});

  @override
  ConsumerState<DepartmentsListPage> createState() => _DepartmentsListPageState();
}

class _DepartmentsListPageState extends ConsumerState<DepartmentsListPage> {
  bool _isAdding = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final departmentsAsync = ref.watch(departmentsProvider);
    final controllerState = ref.watch(departmentControllerProvider);

    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!_isAdding)
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _isAdding = true;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                    label: const Text('Add Department'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Inline Add Form
            if (_isAdding)
              _buildInlineAddForm(controllerState),

            // Main Content Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 16),
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: departmentsAsync.when(
                    data: (departments) {
                      if (departments.isEmpty && !_isAdding) {
                        return _buildEmptyState(context);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            decoration: const BoxDecoration(
                              color: AppTheme.backgroundColor,
                              border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
                            ),
                            child: Row(
                              children: [
                                 Expanded(
                                  flex: 5,
                                  child: Text(
                                    'DEPARTMENT NAME',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppTheme.textSecondaryColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    'ACTIONS',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: AppTheme.textSecondaryColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Table Body
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: departments.length,
                              separatorBuilder: (context, index) => const Divider(height: 1, color: AppTheme.borderColor),
                              itemBuilder: (context, index) {
                                final dept = departments[index];
                                return _buildDepartmentListItem(context, dept);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Error: $e')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInlineAddForm(AsyncValue<void> controllerState) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_business_rounded, color: AppTheme.primaryColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Add Department',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textColor,
                      ),
                    ),
                    if (!isMobile) const SizedBox(height: 8),
                  ],
                ),
              ),
              if (!isMobile) ...[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAdding = false;
                      _nameController.clear();
                    });
                  },
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: controllerState.isLoading ? null : _saveDepartment,
                  child: controllerState.isLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Save'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter department name...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.borderColor)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5)),
            ),
            onSubmitted: (_) => _saveDepartment(),
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isAdding = false;
                      _nameController.clear();
                    });
                  },
                  child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: controllerState.isLoading ? null : _saveDepartment,
                    child: controllerState.isLoading
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveDepartment() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a department name'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await ref.read(departmentControllerProvider.notifier).createDepartment(name: name);
    
    if (mounted) {
      setState(() {
        _isAdding = false;
        _nameController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Text(
                'Department "$name" created successfully',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppTheme.textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(24),
        ),
      );
    }
  }

  Widget _buildDepartmentListItem(BuildContext context, Department dept) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        hoverColor: AppTheme.primaryLight.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.business_rounded, color: AppTheme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        dept.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textColor,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: AppTheme.textSecondaryColor,
                      tooltip: 'Edit Department',
                      onPressed: () => _showEditDialog(context, ref, dept),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                      color: Colors.red.shade400,
                      tooltip: 'Delete Department',
                      onPressed: () => _confirmDelete(context, ref, dept),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref, Department dept) async {
    final editController = TextEditingController(text: dept.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 20 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.edit_document, color: AppTheme.primaryColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Edit Department',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: AppTheme.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Department Name',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: editController,
                autofocus: true,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter department name',
                  hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.business_rounded, color: AppTheme.textSecondaryColor, size: 20),
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                onSubmitted: (value) => Navigator.pop(context, value),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, editController.text),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: AppTheme.primaryColor,
                      elevation: 0,
                    ),
                    child: Text(
                      'Save Changes',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (newName != null && newName.trim().isNotEmpty && newName != dept.name) {
      await ref.read(departmentControllerProvider.notifier).updateDepartment(
            id: dept.id,
            name: newName.trim(),
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Department updated successfully',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.textColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(24),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Department dept) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 20 : 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.delete_sweep_rounded, color: Colors.red.shade600, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Delete Department?',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: AppTheme.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Are you sure you want to delete "${dept.name}"?',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'All doctors assigned to this department will lose this assignment. This action cannot be undone.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.red.shade600,
                      elevation: 0,
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      await ref.read(departmentControllerProvider.notifier).deleteDepartment(dept.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  '${dept.name} deleted successfully',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(24),
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.business_rounded, size: 64, color: AppTheme.primaryColor.withOpacity(0.5)),
          ),
          const SizedBox(height: 24),
          Text(
            'No Departments Found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start by adding your first medical department\nto manage schedules.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.textSecondaryColor,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _isAdding = true;
              });
            },
            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
            label: const Text('Add First Department'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}



