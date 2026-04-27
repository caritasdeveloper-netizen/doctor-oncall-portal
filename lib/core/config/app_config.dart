class AppConfig {
  static const String appName = 'Doctor On-Call';
  static const String authDomain = 'doctor-oncall.app';
  static const String copyright = '© 2026 Doctor On-Call Portal';
  
  static String getEmailFromUsername(String username) {
    if (username.contains('@')) return username;
    return '$username@$authDomain';
  }
}
