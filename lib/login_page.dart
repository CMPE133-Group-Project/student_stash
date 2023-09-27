import 'package:flutter/material.dart';
import 'register_page.dart';

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
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Student', // First line
                style: TextStyle(
                  fontSize: 64.0, // Increase the font size
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
            ),
            Center(
              child: Text(
                'Stash', // Second line
                style: TextStyle(
                  fontSize: 64.0, // Increase the font size
                  fontWeight: FontWeight.bold, // Make it bold
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Add your authentication logic here
                // For example, check if email and password are correct
                // If successful, navigate to the home page
                // Otherwise, show an error message
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RegistrationPage(),
                ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.indigo,
    );
  }
}
