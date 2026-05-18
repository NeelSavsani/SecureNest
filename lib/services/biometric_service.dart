import 'package:local_auth/local_auth.dart';

class BiometricService {

  static final LocalAuthentication auth =
  LocalAuthentication();

  // =========================
  // CHECK DEVICE SUPPORT
  // =========================
  static Future<bool>
  isBiometricAvailable() async {

    bool isSupported =
    await auth.isDeviceSupported();

    bool canCheck =
    await auth.canCheckBiometrics;

    return isSupported && canCheck;
  }

  // =========================
  // AUTHENTICATE USER
  // =========================
  static Future<bool>
  authenticate() async {

    try {

      bool authenticated =
      await auth.authenticate(

        localizedReason:
        'Authenticate to continue',

        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      return authenticated;

    } catch (e) {

      return false;
    }
  }
}