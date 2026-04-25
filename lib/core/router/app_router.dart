import 'package:go_router/go_router.dart';
import 'package:oncall_doctor/features/scheduling/presentation/scheduling_page.dart';
import 'package:oncall_doctor/features/departments/presentation/departments_list_page.dart';
import 'package:oncall_doctor/features/departments/presentation/create_department_page.dart';
import 'package:oncall_doctor/features/doctors/presentation/doctors_list_page.dart';
import 'package:oncall_doctor/features/doctors/presentation/create_doctor_page.dart';
import 'package:oncall_doctor/core/widgets/main_layout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainLayout(
          currentRoute: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            name: 'scheduling',
            builder: (context, state) => const SchedulingPage(),
          ),
          GoRoute(
            path: '/doctors',
            name: 'doctors',
            builder: (context, state) => const DoctorsListPage(),
          ),
          GoRoute(
            path: '/create-doctor',
            name: 'create-doctor',
            builder: (context, state) => const CreateDoctorPage(),
          ),
          GoRoute(
            path: '/departments',
            name: 'departments',
            builder: (context, state) => const DepartmentsListPage(),
          ),
          GoRoute(
            path: '/create-department',
            name: 'create-department',
            builder: (context, state) => const CreateDepartmentPage(),
          ),
        ],
      ),
    ],
    // Add route guards here if auth is implemented
    redirect: (context, state) {
      // Logic for Admin/Manager role checking
      return null;
    },
  );
}
