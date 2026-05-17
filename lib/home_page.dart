import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
    FirebaseAuth.instance.currentUser!;

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "SecureNest",
        ),

        backgroundColor:
        const Color(0xFF183869),

        foregroundColor: Colors.white,

        actions: [

          IconButton(

            onPressed: () async {

              await FirebaseAuth.instance
                  .signOut();

              Navigator.pushReplacement(
                context,

                MaterialPageRoute(
                  builder: (context) =>
                  const LoginPage(),
                ),
              );
            },

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.verified_user,
              size: 90,
              color: Color(0xFF183869),
            ),

            const SizedBox(height: 25),

            Text(
              "Welcome",

              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              user.displayName ??
                  "User",

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF183869),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              user.email ?? "",

              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}