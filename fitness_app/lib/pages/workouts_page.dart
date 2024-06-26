import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class WorkoutTrackerPage extends StatefulWidget {
  final String username;

  WorkoutTrackerPage({required this.username});

  @override
  _WorkoutTrackerPageState createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> {
  final TextEditingController _workoutController = TextEditingController();

  void _logWorkout() async {
    String workout = _workoutController.text;

    if (workout.isNotEmpty) {
      var db = await connectToDb();
      var user = await getUserByUsername(db, widget.username);
      if (user != null) {
        List<dynamic> workouts = user['workouts'] ?? [];
        workouts.add({'date': DateTime.now().toIso8601String(), 'workout': workout});
        await updateUserWorkouts(db, widget.username, workouts);
        _workoutController.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout logged!')));
      }
      await db.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _workoutController,
              decoration: InputDecoration(
                labelText: 'Workout',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logWorkout,
              child: Text('Log Workout'),
            ),
          ],
        ),
      ),
    );
  }
}
