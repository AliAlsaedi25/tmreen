import 'package:flutter/material.dart';

class CoachHomePage extends StatelessWidget {
  final Map<String, dynamic> user;

  CoachHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coach Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, Coach ${user['name']}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitorClients', arguments: user['username']);
              },
              child: Text('Monitor Clients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitorRequests', arguments: user['username']);
              },
              child: Text('Monitor Requests'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/coachMessageLog', arguments: user['username']);
              },
              child: Text('Message Log'),
            ),
          ],
        ),
      ),
    );
  }
}
