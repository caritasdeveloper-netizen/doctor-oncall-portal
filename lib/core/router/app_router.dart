import 'package:go_router/go_router.dart';
import 'package:oncall_doctor/features/scheduling/presentation/scheduling_page.dart';
import 'package:oncall_doctor/features/departments/presentation/departments_list_page.dart';
import 'package:oncall_doctor/features/doctors/presentation/doctors_list_page.dart';
import 'package:oncall_doctor/features/doctors/presentation/create_doctor_page.dart';
import 'package:oncall_doctor/features/auth/presentation/login_page.dart';
import 'package:oncall_doctor/features/auth/providers/auth_provider.dart';
import 'package:oncall_doctor/core/widgets/main_layout.dart';
import 'package:oncall_doctor/features/public_view/presentation/public_oncall_page.dart';
import 'package:oncall_doctor/features/data_import/presentation/excel_upload_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/features/doctors/domain/doctor.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final isAuth = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/oncall',
        name: 'oncall',
        builder: (context, state) => const PublicOnCallPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(
          currentRoute: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            name: 'scheduling',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SchedulingPage(),
            ),
          ),
          GoRoute(
            path: '/doctors',
            name: 'doctors',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DoctorsListPage(),
            ),
          ),
          GoRoute(
            path: '/create-doctor',
            name: 'create-doctor',
            pageBuilder: (context, state) {
              final doctor = state.extra as Doctor?;
              return NoTransitionPage(
                child: CreateDoctorPage(doctor: doctor),
              );
            },
          ),
          GoRoute(
            path: '/departments',
            name: 'departments',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DepartmentsListPage(),
            ),
          ),
          GoRoute(
            path: '/upload-data',
            name: 'upload-data',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExcelUploadPage(),
            ),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (isAuth == null) return null;

      final isLoggingIn = state.uri.path == '/login';
      final isPublicPage = state.uri.path == '/oncall';

      if (!isAuth) {
        if (isLoggingIn || isPublicPage) return null;
        return '/oncall';
      }

      if (isLoggingIn || isPublicPage) {
        return '/';
      }

      return null;
    },
  );
}
