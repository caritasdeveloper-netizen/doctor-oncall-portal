import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/config/app_config.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:oncall_doctor/features/auth/providers/auth_provider.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMobile = MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                'CARITAS Doctor OnCall',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textColor,
                  fontSize: 16,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppTheme.textColor),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: isMobile
          ? Drawer(
              width: 280,
              backgroundColor: Colors.white,
              child: _Sidebar(currentRoute: currentRoute, isDrawer: true),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) _Sidebar(currentRoute: currentRoute),
          Expanded(
            child: ClipRRect(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  final String currentRoute;
  final bool isDrawer;
  const _Sidebar({required this.currentRoute, this.isDrawer = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final email = user?.email ?? '';
    final initials = email.isNotEmpty ? email.substring(0, 2).toUpperCase() : 'U';

    return Container(
      width: isDrawer ? null : 260,
      margin: isDrawer ? EdgeInsets.zero : const EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,

                  child:  Center(
                    child:  Image.asset(
              'assets/logo.webp',
              height: 40,
            ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'CARITAS\nDoctor OnCall',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textColor,
                    fontSize: 16,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          _SidebarItem(
            icon: Icons.grid_view_rounded,
            label: 'Scheduling',
            isActive: currentRoute == '/',
            onTap: () => context.goNamed('scheduling'),
          ),
          _SidebarItem(
            icon: Icons.medical_information_rounded,
            label: 'Doctors',
            isActive: currentRoute == '/doctors' || currentRoute == '/create-doctor',
            onTap: () => context.goNamed('doctors'),
          ),
          _SidebarItem(
            icon: Icons.account_tree_rounded,
            label: 'Departments',
            isActive: currentRoute == '/departments',
            onTap: () => context.goNamed('departments'),
          ),
          const Spacer(),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.redAccent,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Sign Out',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                                color: AppTheme.textColor,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Are you sure you want to log out? You\'ll need to sign in again to access the admin dashboard.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: const BorderSide(color: AppTheme.borderColor),
                                      ),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppTheme.textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      'Sign Out',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                
                if (confirm == true) {
                  ref.read(authStateProvider.notifier).logout();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 16),
                    Text(
                      'Logout',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      initials,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email.split('@')[0],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppTheme.textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Admin Portal',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.isActive 
                ? AppTheme.primaryColor 
                : (_isHovered ? AppTheme.primaryLight.withOpacity(0.4) : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  color: widget.isActive ? Colors.white : AppTheme.textSecondaryColor,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    color: widget.isActive ? Colors.white : AppTheme.textSecondaryColor,
                    fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (widget.isActive) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}



