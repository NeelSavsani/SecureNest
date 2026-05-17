import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {

  final bool isDarkMode;

  const LoginPage({
    super.key,
    this.isDarkMode = false,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  late bool isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = widget.isDarkMode;
  }

  // =========================
  // EMAIL LOGIN
  // =========================
  Future login() async {

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showDialog(
        context: context,
        barrierDismissible: false,

        builder: (context) {

          return AlertDialog(

            title: const Text("Success"),

            content: const Text(
              "Login Successful.",
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
    }

    on FirebaseAuthException catch (e) {

      String message =
          "Something went wrong.";

      if (e.code == 'user-not-found') {

        message =
        "No user found with this email.";
      }

      else if (e.code == 'wrong-password') {

        message =
        "Incorrect password.";
      }

      else if (e.code == 'invalid-email') {

        message =
        "Invalid email address.";
      }

      showDialog(
        context: context,

        builder: (context) {

          return AlertDialog(

            title: const Text(
              "Login Failed",
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
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    // =========================
                    // THEME BUTTON
                    // =========================
                    Align(
                      alignment: Alignment.topRight,

                      child: IconButton(

                        onPressed: () {

                          setState(() {

                            isDarkMode =
                            !isDarkMode;
                          });
                        },

                        icon: Icon(

                          isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.dark_mode_rounded,

                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                    // =========================
                    // MAIN CARD
                    // =========================
                    Container(
                      margin: const EdgeInsets.only(
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
                        BorderRadius.circular(40),
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

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

                          const SizedBox(height: 35),

                          // =========================
                          // TITLE
                          // =========================
                          Text(
                            "Login",

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

                          const SizedBox(height: 40),

                          // =========================
                          // EMAIL FIELD
                          // =========================
                          TextField(
                            controller: emailController,

                            style: TextStyle(
                              color: textColor,
                            ),

                            cursorColor:
                            const Color(0xFF183869),

                            decoration: InputDecoration(

                              labelText: "Email",

                              labelStyle: TextStyle(
                                color:
                                secondaryTextColor,
                              ),

                              floatingLabelStyle:
                              const TextStyle(
                                color:
                                Color(0xFF183869),

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
                                  Color(0xFF183869),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // =========================
                          // PASSWORD FIELD
                          // =========================
                          TextField(
                            controller:
                            passwordController,

                            obscureText:
                            obscurePassword,

                            style: TextStyle(
                              color: textColor,
                            ),

                            cursorColor:
                            const Color(0xFF183869),

                            decoration: InputDecoration(

                              labelText: "Password",

                              labelStyle: TextStyle(
                                color:
                                secondaryTextColor,
                              ),

                              floatingLabelStyle:
                              const TextStyle(
                                color:
                                Color(0xFF183869),

                                fontWeight:
                                FontWeight.bold,
                              ),

                              suffixIcon:
                              IconButton(

                                onPressed: () {

                                  setState(() {

                                    obscurePassword =
                                    !obscurePassword;
                                  });
                                },

                                icon: Icon(

                                  obscurePassword
                                      ? Icons
                                      .visibility_off
                                      : Icons
                                      .visibility,

                                  color:
                                  secondaryTextColor,
                                ),
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
                                  Color(0xFF183869),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // =========================
                          // LOGIN BUTTON
                          // =========================
                          SizedBox(
                            width: double.infinity,
                            height: 55,

                            child: ElevatedButton(
                              onPressed: login,

                              style:
                              ElevatedButton.styleFrom(
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

                                elevation: 0,
                              ),

                              child: const Text(
                                "Login",

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // =========================
                          // TERMS
                          // =========================
                          Center(
                            child: Text(
                              "By Signing In, you agree to\nour Terms & Privacy Policy",

                              textAlign:
                              TextAlign.center,

                              style: TextStyle(
                                color:
                                secondaryTextColor,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =========================
                          // OR
                          // =========================
                          Center(
                            child: Text(
                              "or",

                              style: TextStyle(
                                color:
                                secondaryTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          // =========================
                          // GOOGLE BUTTON
                          // =========================
                          Center(
                            child: GestureDetector(
                              onTap:
                              signInWithGoogle,

                              child: Container(
                                height: 65,
                                width: 65,

                                decoration:
                                BoxDecoration(
                                  color:
                                  Colors.white,

                                  shape:
                                  BoxShape.circle,

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withValues(
                                        alpha: 0.12,
                                      ),

                                      blurRadius: 10,

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
                                    height: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 45),

                          // =========================
                          // REGISTER LINK
                          // =========================
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Text(
                                "Don't have an account? ",

                                style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {

                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPage(
                                            isDarkMode:
                                            isDarkMode,
                                          ),
                                    ),
                                  );
                                },

                                child: Text(
                                  "Register",

                                  style: TextStyle(

                                    color: isDarkMode
                                        ? Colors.white70
                                        : const Color(
                                      0xFF183869,
                                    ),

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize: 15,

                                    decoration:
                                    TextDecoration
                                        .underline,

                                    decorationColor:
                                    isDarkMode
                                        ? Colors.white70
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
}