import 'package:shared_preferences/shared_preferences.dart';

class BiometricPreferences {

  static const String biometricKey =
      "biometric_enabled";

  // =========================
  // ENABLE / DISABLE
  // =========================
  static Future<bool>
  setBiometricEnabled(
      bool value,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    return await prefs.setBool(
      biometricKey,
      value,
    );
  }

  // =========================
  // GET STATUS
  // =========================
  static Future<bool>
  isBiometricEnabled() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getBool(
      biometricKey,
    ) ?? false;
  }
}