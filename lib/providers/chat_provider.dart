import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _items = [];

  List<Chat> get items {
    return [..._items];
  }

  List _usersInChat = [];

  final authToken;
  final authUserId;

  ChatProvider(this.authToken, this.authUserId, this._items);

  List<Chat> fetchByUserId(String userId) {
    // return _items.where((chat) => chat.usersHave == chatId).toList();
  }

  Chat findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetChat() async {
    final url = 'https://fish-mgs.firebaseio.com/chat.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Chat> loadedChat = [];
      extractedData.forEach((chatId, chatData) {
        loadedChat.add(Chat(
          id: chatId,
          avatar: chatData['avatar'],
          name: chatData['name'],
          owner: chatData['owner'],
          hasAcces: chatData['usersHaveAccess'] == null ? false : (chatData['usersHaveAccess'] as Map<String, dynamic>)
              .containsKey(authUserId),
        ));
      });
      _items = loadedChat;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

   Future<void> addChat(Chat chat) async {
    final url = 'https://fish-mgs.firebaseio.com/chat.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'avatar': 'https://titanodrol.com/images/ingr-0.png',
          'name': chat.name,
          'owner': chat.owner,
        }),
      );
      final newChat = Chat(
        avatar: chat.avatar,
        name: chat.name,
        owner: chat.owner,
        id: json.decode(response.body)['name'],
      );
      _items.add(newChat);
      addUserToChat(newChat.id, newChat.owner);
      // _items.insert(0, newChat); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateChat(String id, Chat newChat) async {
    final chatIndex = _items.indexWhere((chat) => chat.id == id);
    if (chatIndex >= 0) {
      final url = 'https://fish-mgs.firebaseio.com/chat/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'avatar': newChat.avatar,
            'name': newChat.name,
            'owner': newChat.owner,
          }));
      _items[chatIndex] = newChat;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteChat(String id) async {
    final url = 'https://fish-mgs.firebaseio.com/chat/$id.json?auth=$authToken';
    final existingChatIndex = _items.indexWhere((chat) => chat.id == id);
    var existingChat = _items[existingChatIndex];
    _items.removeAt(existingChatIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingChatIndex, existingChat);
      notifyListeners();
      // throw HttpException('Could not delete product.');
    }
    existingChat = null;
  }

  Future<void> addUserToChat(String id, String userId) async {
    final url = 'https://fish-mgs.firebaseio.com/chat/$id/usersHaveAccess/$userId.json?auth=$authToken';
    await http.put(url, body: json.encode(true));
  }

}
