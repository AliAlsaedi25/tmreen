import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class ClientWorkoutsPage extends StatefulWidget {
  final String coachUsername;
  final String clientUsername;

  ClientWorkoutsPage({required this.coachUsername, required this.clientUsername});

  @override
  _ClientWorkoutsPageState createState() => _ClientWorkoutsPageState();
}

class _ClientWorkoutsPageState extends State<ClientWorkoutsPage> {
  List<String> workouts = [];
  bool _isLoading = true;
  final TextEditingController _workoutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  void _fetchWorkouts() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var client = await getUserByUsername(db, widget.clientUsername);
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

  void _addWorkout() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var client = await getUserByUsername(db, widget.clientUsername);
      if (client != null) {
        client['workouts'].add(_workoutController.text);

        var collection = db.collection('clients');
        await collection.updateOne(
          mongo.where.eq('username', widget.clientUsername),
          mongo.modify.set('workouts', client['workouts']),
        );

        setState(() {
          workouts = List<String>.from(client['workouts']);
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Workout added')));
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
        title: Text('Client Workouts'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(workouts[index]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _workoutController,
                          decoration: InputDecoration(
                            labelText: 'Add Workout',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addWorkout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
