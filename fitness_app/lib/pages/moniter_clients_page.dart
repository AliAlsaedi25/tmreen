import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';
import 'client_workouts_page.dart';

class MonitorClientsPage extends StatefulWidget {
  final String username;

  MonitorClientsPage({required this.username});

  @override
  _MonitorClientsPageState createState() => _MonitorClientsPageState();
}

class _MonitorClientsPageState extends State<MonitorClientsPage> {
  List<Map<String, dynamic>> clients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  void _fetchClients() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var coach = await getCoachByUsername(db, widget.username);
      if (coach != null) {
        setState(() {
          clients = List<Map<String, dynamic>>.from(coach['clients']
              .map((client) => client is String ? {'username': client} : client)
              .toList());
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
        title: Text('Monitor Clients'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                var client = clients[index];
                return ListTile(
                  title: Text(client['username']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientWorkoutsPage(
                          coachUsername: widget.username,
                          clientUsername: client['username'],
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
