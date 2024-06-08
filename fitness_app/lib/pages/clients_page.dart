import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  _ClientsPageState createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<dynamic> clients = [];

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    final String response = await rootBundle.loadString('assets/clients.json');
    final data = await json.decode(response);
    setState(() {
      clients = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(clients[index]['name']),
            children: (clients[index]['workouts'] as List<dynamic>).map((workout) {
              return ListTile(
                title: Text(workout),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
