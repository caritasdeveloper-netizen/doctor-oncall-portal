class AppConfig {
  static const String appName = 'Caritas Doctor OnCall';
  static const String authDomain = 'caritas-oncall.app';
  static const String copyright = '© 2026 Caritas Doctor On-Call Portal';
  
  static String getEmailFromUsername(String username) {
    if (username.contains('@')) return username;
    return '$username@$authDomain';
  }
}
