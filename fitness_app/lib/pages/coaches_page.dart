import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';
import 'coach_detail.dart';

class CoachesPage extends StatefulWidget {
  final String username;

  CoachesPage({required this.username});

  @override
  _CoachesPageState createState() => _CoachesPageState();
}

class _CoachesPageState extends State<CoachesPage> {
  List<Map<String, dynamic>> coaches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoaches();
  }

  void _fetchCoaches() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var fetchedCoaches = await getAllCoaches(db);
      setState(() {
        coaches = fetchedCoaches;
        _isLoading = false;
      });
      await db.close();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to the database')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coaches'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: coaches.length,
              itemBuilder: (context, index) {
                var coach = coaches[index];
                return ListTile(
                  title: Text(coach['name']),
                  subtitle: Text(coach['about'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoachDetailPage(
                          coach: coach,
                          clientUsername: widget.username, // Pass the client username here
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
