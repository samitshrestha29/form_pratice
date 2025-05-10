import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_pratice/message/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _controller = TextEditingController();
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString('messages');
    if (messagesString != null) {
      final List decodedList = json.decode(messagesString);
      messages = decodedList.map((item) => MessageModel.fromMap(item)).toList();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(messages.map((message) => message.toMap()).toList());
    await prefs.setString('messages', encodedData);
  }

  void _addMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add(MessageModel(title: _controller.text));
      });
      _controller.clear();
      _saveMessages().then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Message')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Message',
              ),
              onSubmitted: (_) => _addMessage(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addMessage,
              child: const Text('Add Message'),
            ),
          ],
        ),
      ),
    );
  }
}
