import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _role = 'client';  // Default role
  bool _isLoading = false;

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final name = _nameController.text;
    if (username.isNotEmpty && name.isNotEmpty) {
      var db = await connectToDb();
      if (db.state == mongo.State.OPEN) {
        if (_role == 'client') {
          var newUser = {'username': username, 'name': name, 'workouts': []};
          await addUser(db, newUser);
        } else if (_role == 'coach') {
          var newCoach = {'username': username, 'name': name, 'about': '', 'clients': [], 'requests': []};
          await addCoach(db, newCoach);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered')));
        await db.close();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to the database')));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _role,
              onChanged: (String? newValue) {
                setState(() {
                  _role = newValue!;
                });
              },
              items: <String>['client', 'coach']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: _isLoading ? CircularProgressIndicator() : Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
