import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final messageText = _messageController.text; // Сохраняем текст сообщения
    final message = {
      'senderId': user.uid,
      'message': messageText,
      'timestamp': DateTime.now(),
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(message);

    _messageController.clear(); // Очищаем контроллер после отправки

    // Отправляем автоматический ответ только если сообщение отправлено клиентом
    if (user.email != 'email@gmail.com') {
      _sendAutoReply(messageText); // Передаем текст сообщения
    }
  }

  Future<void> _sendAutoReply(String userMessage) async {
    String autoReply;

    if (userMessage.toLowerCase().contains('привет')) {
      autoReply = 'Привет! Чем могу помочь?';
    } else if (userMessage.toLowerCase().contains('здравствуйте')) {
      autoReply = 'Здравствуйте! Чем могу помочь?'; // Добавлено значение
    } else if (userMessage.toLowerCase().contains('заказ')) {
      autoReply = 'Спасибо за заказ! Мы скоро свяжемся с вами.';
    } else if (userMessage.toLowerCase().contains('проблема')) {
      autoReply = 'Ой, что случилось? Расскажите подробнее.';
    } else {
      autoReply = 'Я вас не совсем понял. Пожалуйста, уточните вопрос.';
    }

    final autoReplyMessage = {
      'senderId': 'seller',
      'message': autoReply,
      'timestamp': DateTime.now(),
    };

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add(autoReplyMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Чат с продавцом')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isMe = message['senderId'] ==
                        FirebaseAuth.instance.currentUser?.uid;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          message['message'],
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
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
                    decoration: InputDecoration(labelText: 'Сообщение'),
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
