import 'package:flutter/material.dart';

class CoachHomePage extends StatelessWidget {
  final String username;

  CoachHomePage({required this.username});

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
            Text('Welcome, Coach $username'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitorClients', arguments: username);
              },
              child: Text('Monitor Clients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/monitorRequests', arguments: username);
              },
              child: Text('Monitor Requests'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/coachMessageLog', arguments: username);
              },
              child: Text('Message Log'),
            ),
          ],
        ),
      ),
    );
  }
}
