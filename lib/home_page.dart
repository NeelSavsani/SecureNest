import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),

        actions: [

          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },

            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: Center(
        child: Text(
          "Logged in as:\n${user.email}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}