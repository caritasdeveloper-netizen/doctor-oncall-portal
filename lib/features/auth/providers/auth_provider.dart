import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oncall_doctor/core/providers/shared_prefs_provider.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  Stream<User?> build() {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await ref.read(sharedPrefsProvider).setBool('is_logged_in', true);
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await ref.read(sharedPrefsProvider).setBool('is_logged_in', false);
  }
}

@riverpod
bool isAuthenticated(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  return user != null;
}
