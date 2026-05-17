import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {

  final bool isDarkMode;

  const RegisterPage({
    super.key,
    this.isDarkMode = false,
  });

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = widget.isDarkMode;
  }

  // =========================
  // REGISTER USER
  // =========================
  Future register() async {

    // PASSWORD MATCH CHECK
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {

      showDialog(
        context: context,

        builder: (context) {

          return AlertDialog(

            title: const Text(
              "Password Error",
            ),

            content: const Text(
              "Passwords do not match.",
            ),

            actions: [

              TextButton(
                onPressed: () {

                  Navigator.pop(context);
                },

                child: const Text("OK"),
              ),
            ],
          );
        },
      );

      return;
    }

    try {

      // CREATE USER
      UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      // STORE NAME
      await userCredential.user!
          .updateDisplayName(
        nameController.text.trim(),
      );

      // SUCCESS POPUP
      showDialog(
        context: context,

        barrierDismissible: false,

        builder: (context) {

          return AlertDialog(

            title: const Text(
              "Success",
            ),

            content: const Text(
              "Account created successfully.",
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);

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

                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    on FirebaseAuthException catch (e) {

      String message =
          "Something went wrong.";

      if (e.code ==
          'email-already-in-use') {

        message =
        "Account already exists with this email.";
      }

      else if (e.code ==
          'weak-password') {

        message =
        "Password must be at least 6 characters.";
      }

      else if (e.code ==
          'invalid-email') {

        message =
        "Invalid email address.";
      }

      // ERROR POPUP
      showDialog(
        context: context,

        builder: (context) {

          return AlertDialog(

            title: const Text(
              "Registration Failed",
            ),

            content: Text(message),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);
                },

                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // =========================
  // GOOGLE SIGN IN
  // =========================
  Future signInWithGoogle() async {

    final GoogleSignIn googleSignIn =
        GoogleSignIn.instance;

    await googleSignIn.initialize();

    final GoogleSignInAccount gUser =
    await googleSignIn.authenticate();

    final GoogleSignInAuthentication gAuth =
        gUser.authentication;

    final OAuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: gAuth.idToken,
    );

    await FirebaseAuth.instance
        .signInWithCredential(
      credential,
    );
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
      backgroundColor: backgroundColor,

      body: Stack(
        children: [

          // =========================
          // TOP BLUE BACKGROUND
          // =========================
          Container(
            height: 300,
            width: double.infinity,
            color: const Color(0xFF183869),
          ),

          // =========================
          // MAIN CONTENT
          // =========================
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  children: [

                    // =========================
                    // THEME BUTTON
                    // =========================
                    Align(
                      alignment:
                      Alignment.topRight,

                      child: IconButton(

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

                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                    // =========================
                    // MAIN CARD
                    // =========================
                    Container(
                      margin:
                      const EdgeInsets.only(
                        top: 5,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 35,
                      ),

                      decoration: BoxDecoration(
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
                            "Register",

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
                            height: 40,
                          ),

                          // =========================
                          // NAME FIELD
                          // =========================
                          buildTextField(
                            controller:
                            nameController,
                            label: "Name",
                            textColor:
                            textColor,
                            secondaryTextColor:
                            secondaryTextColor,
                            fieldBorderColor:
                            fieldBorderColor,
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // =========================
                          // EMAIL FIELD
                          // =========================
                          buildTextField(
                            controller:
                            emailController,
                            label: "Email",
                            textColor:
                            textColor,
                            secondaryTextColor:
                            secondaryTextColor,
                            fieldBorderColor:
                            fieldBorderColor,
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // =========================
                          // PASSWORD FIELD
                          // =========================
                          buildPasswordField(
                            controller:
                            passwordController,
                            label:
                            "Create Password",
                            obscureText:
                            obscurePassword,
                            onToggle: () {

                              setState(() {

                                obscurePassword =
                                !obscurePassword;
                              });
                            },
                            textColor:
                            textColor,
                            secondaryTextColor:
                            secondaryTextColor,
                            fieldBorderColor:
                            fieldBorderColor,
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          // =========================
                          // CONFIRM PASSWORD FIELD
                          // =========================
                          buildPasswordField(
                            controller:
                            confirmPasswordController,
                            label:
                            "Confirm Password",
                            obscureText:
                            obscureConfirmPassword,
                            onToggle: () {

                              setState(() {

                                obscureConfirmPassword =
                                !obscureConfirmPassword;
                              });
                            },
                            textColor:
                            textColor,
                            secondaryTextColor:
                            secondaryTextColor,
                            fieldBorderColor:
                            fieldBorderColor,
                          ),

                          const SizedBox(
                            height: 40,
                          ),

                          // =========================
                          // REGISTER BUTTON
                          // =========================
                          SizedBox(
                            width:
                            double.infinity,
                            height: 55,

                            child:
                            ElevatedButton(
                              onPressed:
                              register,

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
                                "Register",

                                style:
                                TextStyle(
                                  fontSize:
                                  18,

                                  fontWeight:
                                  FontWeight
                                      .bold,

                                  color: Colors
                                      .white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =========================
                          // OR TEXT
                          // =========================
                          Center(
                            child: Text(
                              "or",

                              style: TextStyle(
                                color:
                                secondaryTextColor,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // =========================
                          // GOOGLE BUTTON
                          // =========================
                          Center(
                            child:
                            GestureDetector(
                              onTap:
                              signInWithGoogle,

                              child: Container(
                                height: 65,
                                width: 65,

                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.white,

                                  shape: BoxShape
                                      .circle,

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withValues(
                                        alpha:
                                        0.12,
                                      ),

                                      blurRadius:
                                      10,

                                      offset:
                                      const Offset(
                                        0,
                                        5,
                                      ),
                                    ),
                                  ],
                                ),

                                child: Center(
                                  child:
                                  Image.asset(
                                    'assets/images/google.png',
                                    height:
                                    32,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 45,
                          ),

                          // =========================
                          // LOGIN LINK
                          // =========================
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                            children: [

                              Text(
                                "Already have an account? ",

                                style:
                                TextStyle(
                                  fontSize:
                                  15,

                                  color:
                                  textColor,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {

                                  Navigator.pushReplacement(
                                    context,

                                    MaterialPageRoute(
                                      builder:
                                          (
                                          context,
                                          ) =>
                                          LoginPage(
                                            isDarkMode:
                                            isDarkMode,
                                          ),
                                    ),
                                  );
                                },

                                child: Text(
                                  "Login",

                                  style:
                                  TextStyle(

                                    color:
                                    isDarkMode
                                        ? Colors
                                        .white70
                                        : const Color(
                                      0xFF183869,
                                    ),

                                    fontWeight:
                                    FontWeight
                                        .bold,

                                    fontSize:
                                    15,

                                    decoration:
                                    TextDecoration
                                        .underline,

                                    decorationColor:
                                    isDarkMode
                                        ? Colors
                                        .white70
                                        : const Color(
                                      0xFF183869,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  // =========================
  // NORMAL TEXT FIELD
  // =========================
  Widget buildTextField({
    required TextEditingController
    controller,
    required String label,
    required Color textColor,
    required Color secondaryTextColor,
    required Color fieldBorderColor,
  }) {

    return TextField(
      controller: controller,

      style: TextStyle(
        color: textColor,
      ),

      cursorColor:
      const Color(0xFF183869),

      decoration: InputDecoration(

        labelText: label,

        labelStyle: TextStyle(
          color: secondaryTextColor,
        ),

        floatingLabelStyle:
        const TextStyle(
          color: Color(0xFF183869),
          fontWeight: FontWeight.bold,
        ),

        enabledBorder:
        UnderlineInputBorder(
          borderSide: BorderSide(
            color: fieldBorderColor,
          ),
        ),

        focusedBorder:
        const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF183869),
            width: 2,
          ),
        ),
      ),
    );
  }

  // =========================
  // PASSWORD FIELD
  // =========================
  Widget buildPasswordField({
    required TextEditingController
    controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
    required Color textColor,
    required Color secondaryTextColor,
    required Color fieldBorderColor,
  }) {

    return TextField(
      controller: controller,

      obscureText: obscureText,

      style: TextStyle(
        color: textColor,
      ),

      cursorColor:
      const Color(0xFF183869),

      decoration: InputDecoration(

        labelText: label,

        labelStyle: TextStyle(
          color: secondaryTextColor,
        ),

        floatingLabelStyle:
        const TextStyle(
          color: Color(0xFF183869),
          fontWeight: FontWeight.bold,
        ),

        suffixIcon: IconButton(

          onPressed: onToggle,

          icon: Icon(

            obscureText
                ? Icons.visibility_off
                : Icons.visibility,

            color: secondaryTextColor,
          ),
        ),

        enabledBorder:
        UnderlineInputBorder(
          borderSide: BorderSide(
            color: fieldBorderColor,
          ),
        ),

        focusedBorder:
        const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF183869),
            width: 2,
          ),
        ),
      ),
    );
  }
}