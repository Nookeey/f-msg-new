import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class ChatListScreen extends StatefulWidget {
  static final routeName = 'chat-list';

  @override
  State<StatefulWidget> createState() {
    return _ChatListScreenState();
  }
}

class _ChatListScreenState extends State<ChatListScreen> {

  List<Chat> chatList = [];

  Widget _buildChatListItem(Chat chat, index) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chat.avatar),
          ),
          title: Text(chat.name),
          subtitle: Text('Last message'),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage()));
            // Navigator.pushNamed<bool>(context, '/message/' + chat.id);
          },
        ),
      ],
    );
  }

  Widget _buildChatList(List<Chat> chat) {
    Widget chatList;
    if (chat.length > 0) {
      chatList = ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildChatListItem(chat[index], index),
        itemCount: chat.length,
      );
    } else {
      chatList = Container();
    }
    return chatList;
  }

  void _fetchAndSetChatList() {
    final chatData = Provider.of<ChatProvider>(context);
    chatData.fetchAndSetChat();
    chatList = chatData.items;
  }
  
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    // print(authData.userId);
    _fetchAndSetChatList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: Center(
        child: _buildChatList(chatList),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // final newChat = Chat(
          //   id: null,
          //   avatar: 'avatarUrl',
          //   name: 'Some chat 2',
          //   owner: authData.userId,
          // );
          // chatData.addChat(newChat);
          chatList.forEach((chat) {
            print(chat.name);
            print(chat.hasAcces);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}