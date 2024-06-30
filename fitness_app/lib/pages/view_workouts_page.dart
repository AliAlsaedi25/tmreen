import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class ViewWorkoutsPage extends StatefulWidget {
  final String username;

  ViewWorkoutsPage({required this.username});

  @override
  _ViewWorkoutsPageState createState() => _ViewWorkoutsPageState();
}

class _ViewWorkoutsPageState extends State<ViewWorkoutsPage> {
  late Future<List<Map<String, dynamic>>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = _fetchWorkouts();
  }

  Future<List<Map<String, dynamic>>> _fetchWorkouts() async {
    var db = await connectToDb();
    var user = await getUserByUsername(db, widget.username);
    await db.close();
    if (user != null) {
      if (user['workouts'] is List) {
        return List<Map<String, dynamic>>.from(user['workouts'].map((workout) {
          if (workout is String) {
            return {'workout': workout, 'date': ''}; // Adjust this as needed
          } else if (workout is Map<String, dynamic>) {
            return workout;
          } else {
            return {'workout': 'Invalid workout format', 'date': ''};
          }
        }));
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View My Workouts'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No workouts logged.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var workout = snapshot.data![index];
                return ListTile(
                  title: Text(workout['workout']),
                  subtitle: Text('Date: ${workout['date']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
