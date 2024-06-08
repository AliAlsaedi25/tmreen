import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class AddWorkoutsPage extends StatefulWidget {
  final String username;

  AddWorkoutsPage({required this.username});

  @override
  _AddWorkoutsPageState createState() => _AddWorkoutsPageState();
}

class _AddWorkoutsPageState extends State<AddWorkoutsPage> {
  final TextEditingController _clientUsernameController = TextEditingController();
  final TextEditingController _workoutController = TextEditingController();
  String _errorMessage = '';

  Future<void> _addWorkout() async {
    final clientUsername = _clientUsernameController.text.trim();
    final workout = _workoutController.text.trim();

    if (clientUsername.isEmpty || workout.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required';
      });
      return;
    }

    try {
      final clientsData = await _loadJsonData('assets/clients.json');
      final clientIndex = clientsData.indexWhere((client) => client['username'] == clientUsername);

      if (clientIndex == -1) {
        setState(() {
          _errorMessage = 'Client not found';
        });
        return;
      }

      clientsData[clientIndex]['workouts'].add(workout);

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/clients.json';
      final file = File(filePath);
      await file.writeAsString(json.encode(clientsData));

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
      print('Error: $e');
    }
  }

  Future<List<dynamic>> _loadJsonData(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Workouts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _clientUsernameController,
              decoration: InputDecoration(labelText: 'Client Username'),
            ),
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(labelText: 'Workout'),
            ),
            ElevatedButton(
              onPressed: _addWorkout,
              child: Text('Add Workout'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
