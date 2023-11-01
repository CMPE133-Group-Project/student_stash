import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:student_stash/main.dart';
import 'register.dart';
import 'db_operations.dart';
import 'current_session.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Student', // First line
                style: TextStyle(
                  fontSize: 64.0, // Increase the font size
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
            ),
            const Center(
              child: Text(
                'Stash', // Second line
                style: TextStyle(
                  fontSize: 64.0, // Increase the font size
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Add your authentication logic here
                // For example, check if email and password are correct
                // If successful, navigate to the home page
                // Otherwise, show an error message
                if (await DbOperations.verifyLogin(
                    emailController.text, passwordController.text)) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.indigo,
    );
  }
}
