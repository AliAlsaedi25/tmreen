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

  void _addWorkout() async {
    var db = await connectToDb();
    var user = await getUserByUsername(db, widget.username);
    if (user != null) {
      List<Map<String, dynamic>> workouts = List<Map<String, dynamic>>.from(
        (user['workouts'] as List).map((workout) => Map<String, dynamic>.from(workout)),
      );
      workouts.add({
        'workout': _workoutController.text,
        'date': DateTime.now().toString(),
      });

      await updateUserWorkouts(db, widget.username, workouts);
      setState(() {});
    }
    await db.close();
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
