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
  final GlobalKey<FormState> _formKey = GlobalKey();
  List<Chat> _chatItems;
  Map<String, String> _chatData = {
    'name': '',
  };

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

  void _showCreateChatDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Create new chat'),
        content: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Chat name'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Chat name cannot be empty';
                    }
                  },
                  onSaved: (value) {
                    _chatData['name'] = value;
                  },
                )
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('Create'),
            onPressed: () {
              _createNewChat();
            },
          )
        ],
      )
    );
  }

 Future<void> _createNewChat() async {
   if(!_formKey.currentState.validate()){
     return;
   }
   _formKey.currentState.save();

   try {
     final _authProvider = Provider.of<AuthProvider>(context, listen: false);
     Chat newChat = Chat(
       id: null,
       name: _chatData['name'],
       owner: _authProvider.userId
     );
     await Provider.of<ChatProvider>(context, listen: false).addChat(newChat);
     Navigator.of(context).pop();
   } catch (e) {
     print(e);
   }
 }

  @override
  Widget build(BuildContext context) {
    final _chatProvider = Provider.of<ChatProvider>(context);
    _chatProvider.fetchAndSetChat();
    _chatItems = _chatProvider.items;
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
        child: _buildChatList(_chatItems),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _showCreateChatDialog()
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}