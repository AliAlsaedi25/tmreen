import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isCoach = false;

  void _signUp() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var existingUser = await getUserByUsername(db, username);
      var existingCoach = await getCoachByUsername(db, username);

      if (existingUser != null || existingCoach != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already exists')),
        );
      } else {
        if (_isCoach) {
          await addCoach(db, {
            'username': username,
            'password': password,
            'name': name,
            'clients': [],
            'requests': [],
            'workouts': [],
          });
        } else {
          await addUser(db, {
            'username': username,
            'password': password,
            'name': name,
            'workouts': [],
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully')),
        );
        Navigator.pop(context);
      }
      await db.close();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the database')),
      );
    }
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
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isCoach,
                  onChanged: (bool? value) {
                    setState(() {
                      _isCoach = value!;
                    });
                  },
                ),
                Text('Sign up as a coach'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
