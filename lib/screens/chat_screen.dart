import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../models/message.dart';

import '../providers/chat_provider.dart';
import '../providers/message_provider.dart';

class ChatScreen extends StatefulWidget {
  static final routeName = 'chat';

  @override
  State<StatefulWidget> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {

  String authUserId;
  String chatId;
  Chat loadedChat;
  List<Message> loadedMessages;

  Widget _buildMessage(Message message, index) {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 40.0,
      color: message.userId == authUserId ? Colors.blue : Colors.grey,
      child: Text(message.message),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    Widget message;
    if (messages.length > 0) {
      message = ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildMessage(messages[index], index),
        itemCount: messages.length,
      );
    } else {
      message = Container();
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    chatId = ModalRoute.of(context).settings.arguments as String;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    loadedChat = chatProvider.findById(chatId);

    final messageProvider = Provider.of<MessageProvider>(context, listen: true);
    messageProvider.fetchAndSetMessageByChatId(chatId);
    loadedMessages = messageProvider.getMessagesByChatId(chatId);

    authUserId = messageProvider.authUserId;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedChat.name),
      ),
      body: Center(
        child: Container(
          child: _buildMessagesList(loadedMessages)
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Message newMessage = Message(
            id: null,
            message: 'Some message ${DateTime.now().second.toString()}',
            timestamp: DateTime.now().toString(),
            userId: authUserId,
            chatId: chatId
          );
          messageProvider.addMessage(newMessage);
        },
      ),
    );
  }
}