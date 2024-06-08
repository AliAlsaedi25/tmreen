import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ClientWorkoutsPage extends StatefulWidget {
  final String clientUsername;

  ClientWorkoutsPage({required this.clientUsername});

  @override
  _ClientWorkoutsPageState createState() => _ClientWorkoutsPageState();
}

class _ClientWorkoutsPageState extends State<ClientWorkoutsPage> {
  final TextEditingController _workoutController = TextEditingController();
  List<dynamic> _workouts = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadClientWorkouts();
  }

  Future<void> _loadClientWorkouts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/clients.json');
      final List<dynamic> clients = json.decode(jsonString);
      final client = clients.firstWhere((client) => client['username'] == widget.clientUsername);
      setState(() {
        _workouts = client['workouts'];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
      print('Error: $e');
    }
  }

  Future<void> _addWorkout() async {
    final workout = _workoutController.text.trim();

    if (workout.isEmpty) {
      setState(() {
        _errorMessage = 'Workout cannot be empty';
      });
      return;
    }

    try {
      final clientsData = await _loadJsonData('assets/clients.json');
      final clientIndex = clientsData.indexWhere((client) => client['username'] == widget.clientUsername);

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

      setState(() {
        _workouts.add(workout);
        _workoutController.clear();
      });
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
        title: Text('Workouts for ${widget.clientUsername}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_workouts[index]),
                  );
                },
              ),
            ),
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(labelText: 'Add Workout'),
            ),
            ElevatedButton(
              onPressed: _addWorkout,
              child: Text('Add Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
