import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oncall_doctor/core/router/app_router.dart';
import 'package:oncall_doctor/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:oncall_doctor/core/providers/shared_prefs_provider.dart';
import 'package:oncall_doctor/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enable high-refresh-rate displays (120Hz ProMotion on iOS/Android)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      child: const OnCallDoctorApp(),
    ),
  );
}

class OnCallDoctorApp extends ConsumerWidget {
  const OnCallDoctorApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Doctor On-Call Scheduler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      builder: (context, child) => ScrollConfiguration(
        behavior: const _SmoothScrollBehavior(),
        child: child!,
      ),
    );
  }
}

/// Makes scrolling feel smooth and responsive on all platforms including web.
class _SmoothScrollBehavior extends ScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
