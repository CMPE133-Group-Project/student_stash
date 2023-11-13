import 'package:flutter/material.dart';
import 'package:student_stash/main.dart';
import 'db_operations.dart';
import 'current_session.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Add your registration logic here
                // Validate inputs, check if passwords match, and create the user account
                if (await DbOperations.createAccount(
                    emailController.text, confirmPasswordController.text)) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ));
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
