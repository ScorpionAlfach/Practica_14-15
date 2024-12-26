import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/chat_screen.dart';

class SellerChatsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SellerChatsScreen({super.key}); // Убрано ключевое слово const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои чаты')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('Нет активных чатов'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final clientId = chat['clientId'] ?? 'Неизвестный клиент';
              final lastMessage = chat['lastMessage'] ?? 'Нет сообщений';
              final lastMessageTime = chat['lastMessageTime'] != null
                  ? (chat['lastMessageTime'] as Timestamp).toDate()
                  : DateTime.now();

              return ListTile(
                title: Text('Чат с клиентом $clientId'),
                subtitle:
                    Text('$lastMessage (${_formatDateTime(lastMessageTime)})'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chat.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
