import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {

  final bool isDarkMode;

  const ResetPasswordPage({
    super.key,
    this.isDarkMode = false,
  });

  @override
  State<ResetPasswordPage> createState() =>
      _ResetPasswordPageState();
}

class _ResetPasswordPageState
    extends State<ResetPasswordPage> {

  final emailController =
  TextEditingController();

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = widget.isDarkMode;
  }

  // =========================
  // RESET PASSWORD
  // =========================
  Future resetPassword() async {

    try {

      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email:
        emailController.text.trim(),
      );

      if (mounted) {

        showDialog(
          context: context,

          barrierDismissible: false,

          builder: (context) {

            return AlertDialog(

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
              ),

              title: const Text(
                "Success",
              ),

              content: Text(
                "Password reset link has been sent successfully to:\n\n${emailController.text.trim()}",
              ),

              actions: [

                ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFF183869,
                    ),

                    foregroundColor:
                    Colors.white,
                  ),

                  onPressed: () {

                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(
                              isDarkMode:
                              isDarkMode,
                            ),
                      ),
                    );
                  },

                  child: const Text(
                    "OK",
                  ),
                ),
              ],
            );
          },
        );
      }
    }

    on FirebaseAuthException catch (e) {

      String message =
          "Something went wrong.";

      if (e.code ==
          'invalid-email') {

        message =
        "Invalid email address.";
      }

      else if (e.code ==
          'user-not-found') {

        message =
        "No account found with this email.";
      }

      if (mounted) {

        showDialog(
          context: context,

          builder: (context) {

            return AlertDialog(

              title: const Text(
                "Reset Failed",
              ),

              content: Text(message),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(context);
                  },

                  child: const Text(
                    "OK",
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final backgroundColor =
    isDarkMode
        ? const Color(0xFF0F172A)
        : const Color(0xFFF5F5F5);

    final cardColor =
    isDarkMode
        ? const Color(0xFF1E293B)
        : Colors.white;

    final textColor =
    isDarkMode
        ? Colors.white
        : Colors.black;

    final secondaryTextColor =
    isDarkMode
        ? Colors.white70
        : Colors.grey;

    final fieldBorderColor =
    isDarkMode
        ? Colors.white38
        : Colors.grey;

    return Scaffold(
      backgroundColor:
      backgroundColor,

      body: Stack(
        children: [

          // =========================
          // TOP BLUE BACKGROUND
          // =========================
          Container(
            height: 300,
            width: double.infinity,

            color: const Color(
              0xFF183869,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  children: [

                    // =========================
                    // TOP BUTTONS
                    // =========================
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        // BACK BUTTON
                        IconButton(

                          onPressed: () {

                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(
                                      isDarkMode:
                                      isDarkMode,
                                    ),
                              ),
                            );
                          },

                          icon: const Icon(
                            Icons
                                .arrow_back_ios_new_rounded,

                            color:
                            Colors.white,
                          ),
                        ),

                        // THEME BUTTON
                        IconButton(

                          onPressed: () {

                            setState(() {

                              isDarkMode =
                              !isDarkMode;
                            });
                          },

                          icon: Icon(

                            isDarkMode
                                ? Icons
                                .wb_sunny_rounded
                                : Icons
                                .dark_mode_rounded,

                            color:
                            Colors.white,

                            size: 30,
                          ),
                        ),
                      ],
                    ),

                    // =========================
                    // MAIN CARD
                    // =========================
                    Container(
                      margin:
                      const EdgeInsets.only(
                        top: 10,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 35,
                      ),

                      decoration:
                      BoxDecoration(
                        color: cardColor,

                        borderRadius:
                        BorderRadius.circular(
                          40,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          // =========================
                          // LOGO
                          // =========================
                          Center(
                            child: Image.asset(
                              'assets/images/RSIcon.png',
                              height: 90,
                            ),
                          ),

                          const SizedBox(
                            height: 35,
                          ),

                          // =========================
                          // TITLE
                          // =========================
                          Text(
                            "Reset Password",

                            style: TextStyle(
                              fontSize: 32,
                              fontWeight:
                              FontWeight.bold,

                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(
                                0xFF183869,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                              Text(
                                "Enter your email to receive password reset link.",

                                style: TextStyle(
                                  color:
                                  secondaryTextColor,

                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Also check the 'Spam' folder for the password reset link.",

                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.orange.shade200
                                      : Colors.orange.shade800,

                                  fontSize: 13,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          // =========================
                          // EMAIL FIELD
                          // =========================
                          TextField(
                            controller:
                            emailController,

                            style: TextStyle(
                              color:
                              textColor,
                            ),

                            cursorColor:
                            const Color(
                              0xFF183869,
                            ),

                            decoration:
                            InputDecoration(

                              labelText:
                              "Email",

                              labelStyle:
                              TextStyle(
                                color:
                                secondaryTextColor,
                              ),

                              floatingLabelStyle:
                              const TextStyle(
                                color: Color(
                                  0xFF183869,
                                ),

                                fontWeight:
                                FontWeight.bold,
                              ),

                              enabledBorder:
                              UnderlineInputBorder(
                                borderSide:
                                BorderSide(
                                  color:
                                  fieldBorderColor,
                                ),
                              ),

                              focusedBorder:
                              const UnderlineInputBorder(
                                borderSide:
                                BorderSide(
                                  color:
                                  Color(
                                    0xFF183869,
                                  ),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 50,
                          ),

                          // =========================
                          // NEXT BUTTON
                          // =========================
                          SizedBox(
                            width:
                            double.infinity,

                            height: 55,

                            child:
                            ElevatedButton(

                              onPressed:
                              resetPassword,

                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                const Color(
                                  0xFF183869,
                                ),

                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    15,
                                  ),
                                ),
                              ),

                              child: const Text(
                                "Next",

                                style:
                                TextStyle(
                                  fontSize:
                                  18,

                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  color:
                                  Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}