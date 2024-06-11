import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class MonitorRequestsPage extends StatefulWidget {
  final String username;

  MonitorRequestsPage({required this.username});

  @override
  _MonitorRequestsPageState createState() => _MonitorRequestsPageState();
}

class _MonitorRequestsPageState extends State<MonitorRequestsPage> {
  List<String> requests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  void _fetchRequests() async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var coach = await getCoachByUsername(db, widget.username);
      if (coach != null) {
        setState(() {
          requests = List<String>.from(coach['requests']);
          _isLoading = false;
        });
      }
      await db.close();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to connect to the database')));
    }
  }

  void _approveRequest(String clientUsername) async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var coach = await getCoachByUsername(db, widget.username);
      if (coach != null) {
        // Remove the client from the requests array
        coach['requests'].remove(clientUsername);

        // Ensure all entries in the clients array are objects with a username field
        coach['clients'] = List<Map<String, dynamic>>.from(coach['clients']
            .map((client) => client is String ? {'username': client} : client)
            .toList());

        // Add the client to the clients array
        coach['clients'].add({'username': clientUsername});

        // Update the coach in the database
        var collection = db.collection('coaches');
        await collection.updateOne(
          mongo.where.eq('username', widget.username),
          mongo.modify.set('requests', coach['requests']).set('clients', coach['clients']),
        );

        setState(() {
          requests = List<String>.from(coach['requests']);
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Client approved')));
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
        title: Text('Monitor Requests'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests[index];
                return ListTile(
                  title: Text(request),
                  trailing: ElevatedButton(
                    onPressed: () => _approveRequest(request),
                    child: Text('Approve'),
                  ),
                );
              },
            ),
    );
  }
}
