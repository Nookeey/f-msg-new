import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat.dart';
import '../models/message.dart';

import '../providers/chat_provider.dart';
import '../providers/message_provider.dart';
import 'chat_edit_screen.dart';

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
  TextEditingController textFieldController;
  TextInputAction _textInputAction = TextInputAction.newline;
  String _message = '';

  double _fontSize = 15.0;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
      _prefs.then((SharedPreferences prefs) {
      
      bool enterIsSend = true;
      setState(() {
        if(enterIsSend) {
          _textInputAction = TextInputAction.send;
        }
        else {
          _textInputAction = TextInputAction.newline;
        }
      });
    });

    // _chat = widget.chat;
    // int chatId = widget.chat?.id ?? widget.id;

    // _fMessages =
    // ChatService.getChat(chatId).then((chat) {
    //   setState(() {
    //     _chat = chat;
    //     _messages = chat.messages.reversed.toList();
    //   });
    // });

    textFieldController = new TextEditingController()
      ..addListener(() {
        setState(() {
          _message = textFieldController.text;
        });
      });
  }

  // Widget _buildMessage(Message message, index) {
  //   return Container(
  //     margin: EdgeInsets.all(10.0),
  //     height: 40.0,
  //     color: message.userId == authUserId ? Colors.blue : Colors.grey,
  //     child: Text(message.message),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   chatId = ModalRoute.of(context).settings.arguments as String;

  //   final chatProvider = Provider.of<ChatProvider>(context, listen: false);
  //   loadedChat = chatProvider.findById(chatId);

  //   final messageProvider = Provider.of<MessageProvider>(context, listen: true);
  //   messageProvider.fetchAndSetMessageByChatId(chatId);
  //   loadedMessages = messageProvider.getMessagesByChatId(chatId);

  //   authUserId = messageProvider.authUserId;
    
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(loadedChat.name),
  //     ),
  //     body: Center(
  //       child: Container(
  //         child: _buildMessagesList(loadedMessages)
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         final Message newMessage = Message(
  //           id: null,
  //           message: 'Some message ${DateTime.now().second.toString()}',
  //           timestamp: DateTime.now().toString(),
  //           userId: authUserId,
  //           chatId: chatId
  //         );
  //         messageProvider.addMessage(newMessage);
  //       },
  //     ),
  //   );
  // }

  Widget _buildMessage(Message message, index) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
          message.userId == authUserId ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.grey,
                        offset: new Offset(1.0, 1.0),
                        blurRadius: 1.0)
                  ],
                  color: message.userId == authUserId ? Colors.green[100] : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              constraints: BoxConstraints(
                minWidth: 100.0,
                maxWidth: 280.0,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      minWidth: 100.0,
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: _fontSize,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              // new DateFormat('HH:mm').format(message.timestamp),
                              message.timestamp,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: _fontSize,
                              ),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            message.userId == authUserId
                                ? Container() //_getIcon()
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ],
    );
  }

  // Widget _getIcon() {
  //   if(!isSent) {
  //     return Icon(
  //       Icons.check,
  //       size: 18.0,
  //       color: Colors.grey,
  //     );
  //   }
  //   return Icon(
  //     Icons.done_all,
  //     size: 18.0,
  //     color:
  //     isRead ? blueCheckColor : Colors.grey,
  //   );
  // }

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

  void _sendMessage() {
    if(_message == null || _message.isEmpty) return;
    DateTime now = DateTime.now();

    final Message newMessage = Message(
      id: null,
      message: _message,
      timestamp: DateFormat('HH:mm').format(now).toString(),
      userId: authUserId,
      chatId: chatId
    );

    Provider.of<MessageProvider>(context).addMessage(newMessage);
        
    setState(() {
      _message = '';
      textFieldController.text = '';
    });
    
  }

  @override
  Widget build(BuildContext context) {
    chatId = ModalRoute.of(context).settings.arguments as String;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    loadedChat = chatProvider.findById(chatId);

    final messageProvider = Provider.of<MessageProvider>(context);
    messageProvider.fetchAndSetMessageByChatId(chatId);
    loadedMessages = messageProvider.getMessagesByChatId(chatId);

    authUserId = messageProvider.authUserId;

    return Scaffold(
      appBar: AppBar(
        leading: FlatButton(
          shape: CircleBorder(),
          padding: EdgeInsets.only(left: 1.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_back,
                size: 24.0,
                color: Colors.white,
              ),
              CircleAvatar(
                radius: 15.0,
                backgroundImage: loadedChat.avatar == null ? null : NetworkImage(loadedChat.avatar),
              )
            ],
          ),
        ),
        title: Material(
          color: Colors.white.withOpacity(0.0),
          child: InkWell(
            onTap: () {
              
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        loadedChat.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ChatEditScreen.routeName,
                    arguments: chatId
                  );
                  // Scaffold.of(context).showSnackBar(
                  //     SnackBar(content: Text('Edit Button tapped'))
                  // );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: _buildMessagesList(loadedMessages)
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(const Radius.circular(30.0)),
                      color: Colors.grey[800],
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          padding: const EdgeInsets.all(0.0),
                          disabledColor: Colors.grey[700],
                          color: Colors.green[100],
                          icon: Icon(Icons.insert_emoticon),
                          onPressed: () {},
                        ),
                        Flexible(
                          child: TextField(
                            controller: textFieldController,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: _textInputAction,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(0.0),
                              hintText: 'Type a message',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 16.0,
                              ),
                              counterText: '',
                            ),
                            onSubmitted: (String text) {
                              if(_textInputAction == TextInputAction.send) {
                                _sendMessage();
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            maxLength: 100,
                          ),
                        ),
                        IconButton(
                          color: Colors.grey[700],
                          icon: Icon(Icons.attach_file),
                          onPressed: () {},
                        ),
                        _message.isEmpty || _message == null
                            ? IconButton(
                                color: Colors.grey[700],
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {},
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: FloatingActionButton(
                    elevation: 2.0,
                    backgroundColor: Colors.teal[800],
                    foregroundColor: Colors.white,
                    child: _message.isEmpty || _message == null
                        ? Icon(Icons.settings_voice)
                        : Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}