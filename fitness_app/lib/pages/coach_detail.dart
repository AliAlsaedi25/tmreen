import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../services/mongo_service.dart';

class CoachDetailPage extends StatelessWidget {
  final Map<String, dynamic> coach;
  final String clientUsername;

  CoachDetailPage({required this.coach, required this.clientUsername});

  void _requestToRegister(BuildContext context) async {
    var db = await connectToDb();
    if (db.state == mongo.State.OPEN) {
      var coachData = await getCoachByUsername(db, coach['username']);
      if (coachData != null) {
        // Add the client's username to the requests array if not already present
        if (!coachData['requests'].contains(clientUsername)) {
          coachData['requests'].add(clientUsername);

          var collection = db.collection('coaches');
          await collection.updateOne(
            mongo.where.eq('username', coach['username']),
            mongo.modify.set('requests', coachData['requests']),
          );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request sent')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request already sent')));
        }
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
        title: Text('Coach Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name: ${coach['name']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'About: ${coach['about'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _requestToRegister(context),
              child: Text('Request to Register'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement message coach logic here
              },
              child: Text('Message Coach'),
            ),
          ],
        ),
      ),
    );
  }
}
