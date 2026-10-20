import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPassword = 'user_password';

  static Future<void> cadastrarUsuario(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPassword, senha);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  static Future<bool> validarLogin(String email, String senha) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_keyUserEmail) ?? '';
    final savedPassword = prefs.getString(_keyUserPassword) ?? '';

    if (email == savedEmail && senha == savedPassword && email.isNotEmpty) {
      await prefs.setBool(_keyIsLoggedIn, true);
      return true;
    }
    return false;
  }

  static Future<bool> isLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String> getEmailUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail) ?? '';
  }

  static Future<void> encerrarSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}