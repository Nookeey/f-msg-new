import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat.dart';

import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

import '../screens/chat_screen.dart';

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
       avatar: 'https://titanodrol.com/images/ingr-0.png',
       name: _chatData['name'],
       owner: _authProvider.userId
     );
     await Provider.of<ChatProvider>(context, listen: false).addChat(newChat);
     Navigator.of(context).pop();
   } catch (e) {
     print(e);
   }
 }

  // @override
  // Widget build(BuildContext context) {
  //   final _chatProvider = Provider.of<ChatProvider>(context);
  //   _chatProvider.fetchAndSetChat();
  //   _chatItems = _chatProvider.items;
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Chats'),
  //       actions: <Widget>[
  //         IconButton(
  //           icon: Icon(Icons.exit_to_app),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //             Navigator.of(context).pushReplacementNamed('/');
  //             Provider.of<AuthProvider>(context, listen: false).logout();
  //           },
  //         )
  //       ],
  //     ),
  //     body: Center(
  //       child: _buildChatList(_chatItems),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () => {
  //         _showCreateChatDialog()
  //       },
  //       child: Icon(Icons.add),
  //       backgroundColor: Colors.blue,
  //     ),
  //   );
  // }

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
            Navigator.of(context).pushNamed(
              ChatScreen.routeName,
              arguments: chat.id
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Chats',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 25.0
        ),
      ),
      leading: InkWell(
        onTap: () {
          // Go to user profile
        },
        child: Padding(
          padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
          child: CircleAvatar(
            // backgroundImage: NetworkImage(""),
            radius: 25.0,
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.white
          ),
          onPressed: () {},
        )
      ],
      elevation: 0.0,
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, right: 16.0, bottom: 16.0),
      child: Container(
        height: 45.0,
        width: 210.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.black12
        ),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: 'Search',
          ),
        ),
      ),
    );
  }

   Widget _buildCircleProfs(Chat chat, int index, String time, bool isOnline) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: chat.id
          );
        },
        child: Row(
          children: <Widget>[
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(chat.avatar),
                  radius: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(42.0, 42.0, 3.0, 2.0),
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        color: isOnline == true ? Colors.green : Colors.grey,
                        border: Border.all(
                          width: 4.0,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chat.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "last message",
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 2.0,
                    ),
                    Text(
                      time,
                      style: TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(List<Chat> chat) {
    Widget chatList;
    if (chat.length > 0) {
      chatList = ListView.builder(
        // itemBuilder: (BuildContext context, int index) => _buildChatListItem(chat[index], index),
        itemBuilder: (BuildContext context, int index) => _buildCircleProfs(chat[index], index, '03:240', false),
        itemCount: chat.length,
      );
    } else {
      chatList = Container();
    }
    return chatList;
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message,
              size: 30.0,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 40.0,
          ),
          IconButton(
            icon: Icon(
              Icons.people,
              size: 30.0,
            ),
            onPressed: () {},
          ),
          SizedBox(
            width: 40.0,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30.0,
            ),
            onPressed: () {
              _showCreateChatDialog();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _chatProvider = Provider.of<ChatProvider>(context);
    _chatProvider.fetchAndSetChat();
    _chatItems = _chatProvider.items;

    return Scaffold(
      bottomNavigationBar: _buildBottomAppBar(),
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0, left: 16.0, bottom: 8.0),
        child: _buildChatList(_chatItems),
        // child: ListView(
        //   children: <Widget>[
        //     _buildSearchBar(),
        //     Padding(
        //       padding: EdgeInsets.only(top: 8.0),
        //       child: Container(height: 100.0, child: _circular()),
        //     ),
        //     _buildChatList(_chatItems),           
        //   ],
        // ),
      ),
    );
  }
}

  // Widget _buildCircleProfss(String name, String imgUrl, bool isOnline) {
  //   return Container(
  //     decoration: BoxDecoration(shape: BoxShape.circle),
  //     child: Column(
  //       children: <Widget>[
  //         Stack(
  //           fit: StackFit.passthrough,
  //           children: <Widget>[
  //             CircleAvatar(
  //               backgroundImage: NetworkImage(imgUrl),
  //               radius: 25.0,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(35.0, 35.0, 3.0, 2.0),
  //               child: Container(
  //                 width: 20.0,
  //                 height: 20.0,
  //                 decoration: BoxDecoration(
  //                     color: isOnline == true ? Colors.green : Colors.grey,
  //                     border: Border.all(
  //                       width: 4.0,
  //                       color: Colors.white,
  //                     ),
  //                     borderRadius: BorderRadius.circular(15.0)),
  //               ),
  //             )
  //           ],
  //         ),
  //         SizedBox(
  //           height: 1.0,
  //         ),
  //         Text(name,style: TextStyle(color: Colors.grey),),
  //       ],
  //     ),
  //   );
  // }

  // Widget _circular() {
  //   return ListView(
  //     shrinkWrap: true,
  //     scrollDirection: Axis.horizontal,
  //     children: <Widget>[
  //       Column(
  //         children: <Widget>[
  //           CircleAvatar(
  //             radius: 25.0,
  //             child: Center(
  //                 child: IconButton(
  //                     icon: Icon(
  //                       Icons.add,
  //                       color: Colors.white,
  //                       size: 32.0,
  //                     ),
  //                     onPressed: () {})),
  //             backgroundColor: Colors.black12,
  //           ),
  //           SizedBox(
  //             height: 6.5,
  //           ),
  //           Text("Your Story",style: TextStyle(color: Colors.grey),)
  //         ],
  //       ),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Ankur",
  //           "https://images.pexels.com/photos/620340/pexels-photo-620340.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //           false),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Stella",
  //           "https://images.pexels.com/photos/1755385/pexels-photo-1755385.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //           true),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Rosy",
  //           "https://images.pexels.com/photos/1766938/pexels-photo-1766938.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
  //           true),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Ani",
  //           "https://images.pexels.com/photos/1399288/pexels-photo-1399288.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           false),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Gabriela",
  //           "https://images.pexels.com/photos/1684915/pexels-photo-1684915.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           true),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Marsh",
  //           "https://images.pexels.com/photos/1759549/pexels-photo-1759549.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           false),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Rudolf",
  //           "https://images.pexels.com/photos/1757011/pexels-photo-1757011.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           true),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Shaun",
  //           "https://images.pexels.com/photos/1756366/pexels-photo-1756366.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           false),
  //       SizedBox(
  //         width: 20.0,
  //       ),
  //       _buildCircleProfss(
  //           "Jason",
  //           "https://images.pexels.com/photos/935993/pexels-photo-935993.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //           true)
  //     ],
  //   );
  // }