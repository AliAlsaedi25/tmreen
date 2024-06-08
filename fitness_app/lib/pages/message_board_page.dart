import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MessageBoardPage extends StatefulWidget {
  final String clientUsername;
  final String coachUsername;

  MessageBoardPage({required this.clientUsername, required this.coachUsername});

  @override
  _MessageBoardPageState createState() => _MessageBoardPageState();
}

class _MessageBoardPageState extends State<MessageBoardPage> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/messages_${widget.clientUsername}_${widget.coachUsername}.json';
      final file = File(filePath);

      if (file.existsSync()) {
        final jsonString = await file.readAsString();
        setState(() {
          _messages = List<Map<String, String>>.from(json.decode(jsonString));
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final newMessage = {
      'sender': widget.clientUsername,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    };

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/messages_${widget.clientUsername}_${widget.coachUsername}.json';
      final file = File(filePath);
      await file.writeAsString(json.encode(_messages));
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Board with ${widget.coachUsername}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['message']!),
                  subtitle: Text('From: ${message['sender']} at ${message['timestamp']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
