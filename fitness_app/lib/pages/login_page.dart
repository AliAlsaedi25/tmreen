import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isCoach = false;

  Future<bool> _checkIfCoach(String username) async {
    final jsonString = await rootBundle.loadString('assets/coaches.json');
    final List<dynamic> coaches = json.decode(jsonString);
    return coaches.any((coach) => coach['username'] == username);
  }

  void _login() async {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      _isCoach = await _checkIfCoach(username);
      if (_isCoach) {
        Navigator.pushReplacementNamed(context, '/coachHome', arguments: username);
      } else {
        Navigator.pushReplacementNamed(context, '/home', arguments: username);
      }
    }
  }

  void _signup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: _signup,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
