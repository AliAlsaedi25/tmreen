import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'message_board_page.dart'; // Import the Message Board Page

class CoachMessageLogPage extends StatefulWidget {
  final String username;

  CoachMessageLogPage({required this.username});

  @override
  _CoachMessageLogPageState createState() => _CoachMessageLogPageState();
}

class _CoachMessageLogPageState extends State<CoachMessageLogPage> {
  List<Map<String, dynamic>> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final files = directory.listSync().where((file) => file.path.contains('messages_${widget.username}_'));
      for (var file in files) {
        final jsonString = await File(file.path).readAsString();
        final List<Map<String, String>> messages = List<Map<String, String>>.from(json.decode(jsonString));
        if (messages.isNotEmpty) {
          final otherUser = file.path.split('_').last.split('.').first;
          setState(() {
            _conversations.add({'username': otherUser, 'messages': messages});
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Log'),
      ),
      body: ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          final lastMessage = conversation['messages'].last['message'];
          return ListTile(
            title: Text('Conversation with ${conversation['username']}'),
            subtitle: Text('Last message: $lastMessage'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageBoardPage(
                    clientUsername: conversation['username'],
                    coachUsername: widget.username,
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
