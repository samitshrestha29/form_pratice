import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_pratice/message/message.dart';
import 'package:form_pratice/message/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future<void> _loadMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString('messages');
    if (messagesString != null) {
      final List decodedList = json.decode(messagesString);
      setState(() {
        messages =
            decodedList.map((item) => MessageModel.fromMap(item)).toList();
      });
    }
  }

  Future<void> _saveMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(messages.map((message) => message.toMap()).toList());
    await prefs.setString('messages', encodedData);
  }

  void _removeMessageAt(int index) {
    setState(() {
      messages.removeAt(index);
    });
    _saveMessage();
  }

  Future<void> _navigateToMessageScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MessageScreen(),
      ),
    );
    _loadMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _navigateToMessageScreen,
            child: const Text('Go to Add Message'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: messages.isEmpty
                ? const Center(child: Text('No messages added yet.'))
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text(message.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeMessageAt(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
