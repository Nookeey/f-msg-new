import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';

import '../models/chat.dart';

class ChatEditScreen extends StatefulWidget {
  static final routeName = 'chat-edit';

  @override
  State<StatefulWidget> createState() {
    return _ChatEditScreenState();
  }
}

class _ChatEditScreenState extends State<ChatEditScreen> {

  Chat chat;

  @override
  Widget build(BuildContext context) {
    String chatId = ModalRoute.of(context).settings.arguments as String;
    chat = Provider.of<ChatProvider>(context).findById(chatId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit chat'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(chat.id),
            Text(chat.name),
            Text(chat.owner),
            Text(chat.avatar),
          ],
        )
      ),
    );
  }
}