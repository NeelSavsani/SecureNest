import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'services/biometric_service.dart';
import 'services/biometric_preferences.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();

    loadBiometricStatus();
  }

  // =========================
  // LOAD BIOMETRIC STATUS
  // =========================
  Future loadBiometricStatus() async {

    biometricEnabled =
    await BiometricPreferences
        .isBiometricEnabled();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final user =
    FirebaseAuth.instance.currentUser!;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF5F7FA),

      appBar: AppBar(

        title: const Text(
          "SecureNest",
        ),

        centerTitle: true,

        backgroundColor:
        const Color(0xFF183869),

        foregroundColor: Colors.white,

        elevation: 0,

        actions: [

          IconButton(

            onPressed: () async {

              // DISABLE BIOMETRIC
              await BiometricPreferences
                  .setBiometricEnabled(false);

              // SIGN OUT
              await FirebaseAuth.instance
                  .signOut();

              if (mounted) {

                Navigator.pushReplacement(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                    const LoginPage(),
                  ),
                );
              }
            },

            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 30),

              // =========================
              // PROFILE CARD
              // =========================
              Container(
                width: double.infinity,

                padding:
                const EdgeInsets.all(25),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(30),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.06,
                      ),

                      blurRadius: 15,

                      offset:
                      const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // =========================
                    // USER ICON
                    // =========================
                    Container(
                      height: 110,
                      width: 110,

                      decoration: const BoxDecoration(
                        color:
                        Color(0xFF183869),

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // WELCOME TEXT
                    // =========================
                    const Text(
                      "Welcome",

                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                        FontWeight.bold,

                        color: Color(0xFF183869),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================
                    // USER NAME
                    // =========================
                    Text(
                      user.displayName ??
                          "User",

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.w600,

                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // EMAIL
                    // =========================
                    Text(
                      user.email ?? "",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 16,
                        color:
                        Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // =========================
              // SECURITY SETTINGS CARD
              // =========================
              Container(
                width: double.infinity,

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(25),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.06,
                      ),

                      blurRadius: 15,

                      offset:
                      const Offset(0, 5),
                    ),
                  ],
                ),

                child: Padding(
                  padding:
                  const EdgeInsets.all(10),

                  child: Column(
                    children: [

                      // =========================
                      // TITLE
                      // =========================
                      const Padding(
                        padding:
                        EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),

                        child: Row(
                          children: [

                            Icon(
                              Icons.security,
                              color:
                              Color(0xFF183869),
                            ),

                            SizedBox(width: 10),

                            Text(
                              "Security Settings",

                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,

                                color:
                                Color(0xFF183869),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // =========================
                      // BIOMETRIC SWITCH
                      // =========================
                      SwitchListTile(

                        secondary: const Icon(
                          Icons.fingerprint,
                          color:
                          Color(0xFF183869),
                        ),

                        title: const Text(
                          "Biometric Login",
                        ),

                        subtitle: const Text(
                          "Enable fingerprint authentication",
                        ),

                        value:
                        biometricEnabled,

                        activeColor:
                        const Color(0xFF183869),

                        onChanged:
                            (value) async {

                          // =========================
                          // ENABLE BIOMETRIC
                          // =========================
                          if (value) {

                            // CHECK SUPPORT
                            bool available =
                            await BiometricService
                                .isBiometricAvailable();

                            if (!available) {

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(

                                const SnackBar(
                                  content: Text(
                                    "Biometric not available on this device.",
                                  ),
                                ),
                              );

                              return;
                            }

                            // AUTHENTICATE
                            bool authenticated =
                            await BiometricService
                                .authenticate();

                            if (authenticated) {

                              // SAVE STATUS
                              await BiometricPreferences
                                  .setBiometricEnabled(
                                true,
                              );

                              // REFRESH UI
                              bool enabled =
                              await BiometricPreferences
                                  .isBiometricEnabled();

                              setState(() {

                                biometricEnabled =
                                    enabled;
                              });

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(

                                const SnackBar(
                                  content: Text(
                                    "Biometric Enabled",
                                  ),
                                ),
                              );
                            }

                            else {

                              setState(() {

                                biometricEnabled =
                                false;
                              });

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(

                                const SnackBar(
                                  content: Text(
                                    "Authentication Failed",
                                  ),
                                ),
                              );
                            }
                          }

                          // =========================
                          // DISABLE BIOMETRIC
                          // =========================
                          else {

                            await BiometricPreferences
                                .setBiometricEnabled(
                              false,
                            );

                            setState(() {

                              biometricEnabled =
                              false;
                            });

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(

                              const SnackBar(
                                content: Text(
                                  "Biometric Disabled",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}