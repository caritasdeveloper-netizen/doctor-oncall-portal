import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Removed problematic external texture
          Row(

            children: [
              _Sidebar(currentRoute: currentRoute),
              Expanded(
                child: Column(
                  children: [
                    _Header(currentRoute: currentRoute),
                    Expanded(
                      child: ClipRRect(
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String currentRoute;
  const _Sidebar({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
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
          // Logo with unique styling
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'OnCall',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textColor,
                    fontSize: 20,
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
            isActive: currentRoute == '/departments' || currentRoute == '/create-department',
            onTap: () => context.goNamed('departments'),
          ),
          const Spacer(),
          // Unique Profile Section
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
                      'AR',
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
                          'Alex Rivera',
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
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
                  color: widget.isActive ? Colors.white : (widget.isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor),
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: GoogleFonts.plusJakartaSans(
                    color: widget.isActive ? Colors.white : (widget.isActive ? AppTheme.primaryColor : AppTheme.textSecondaryColor),
                    fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (widget.isActive)
                  const Spacer(),
                if (widget.isActive)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String currentRoute;
  const _Header({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    String title = 'Dashboard';
    if (currentRoute == '/doctors') title = 'Medical Staff';
    if (currentRoute == '/create-doctor') title = 'Register Doctor';
    if (currentRoute == '/departments') title = 'Departments';
    if (currentRoute == '/create-department') title = 'New Department';

    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: AppTheme.textColor,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  'Optimizing hospital workflow with intelligent on-call management.',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Glassmorphic Search Bar
          Container(
            width: 340,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search staff or departments...',
                    hintStyle: GoogleFonts.plusJakartaSans(color: AppTheme.textSecondaryColor, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondaryColor, size: 20),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          _HeaderAction(icon: Icons.notifications_none_rounded, hasBadge: true),
          const SizedBox(width: 12),
          _HeaderAction(icon: Icons.settings_rounded),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;
  const _HeaderAction({required this.icon, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: AppTheme.textColor, size: 20),
          if (hasBadge)
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

