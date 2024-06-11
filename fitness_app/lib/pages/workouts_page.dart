import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class WorkoutsPage extends StatefulWidget {
  final String username;

  WorkoutsPage({required this.username});

  @override
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<String> workouts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  void _fetchWorkouts() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var client = await getUserByUsername(db, widget.username);
      if (client != null) {
        setState(() {
          workouts = List<String>.from(client['workouts']);
          _isLoading = false;
        });
      }
      await db.close();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to the database')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Workouts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(workouts[index]),
                );
              },
            ),
    );
  }
}
