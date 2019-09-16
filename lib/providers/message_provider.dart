import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _items = [];

  List<Message> get items {
    return [..._items];
  }

  final authToken;
  final authUserId;

  MessageProvider(this.authToken, this.authUserId, this._items);

  Message findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Message> getMessagesByChatId(String chatId) {
    return _items.where((Message message) => message.chatId == chatId).toList();
  }

  Future<void> fetchAndSetMessage() async {
    final url = 'https://fish-mgs.firebaseio.com/messages.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Message> loadedMessage = [];
      extractedData.forEach((messageId, messageData) {
        loadedMessage.add(Message(
          id: messageId,
          message: messageData['message'],
          timestamp: messageData['timestamp'],
          userId: messageData['userId'],
          chatId: messageData['chatId'],
        ));
      });
      _items = loadedMessage;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

  Future<void> fetchAndSetMessageByChatId(String chatId) async {
    final url = 'https://fish-mgs.firebaseio.com/messages.json?chatId=$chatId&auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Message> loadedMessage = [];
      extractedData.forEach((messageId, messageData) {
        loadedMessage.add(Message(
          id: messageId,
          message: messageData['message'],
          timestamp: messageData['timestamp'],
          userId: messageData['userId'],
          chatId: messageData['chatId'],
        ));
      });
      _items = loadedMessage;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

   Future<void> addMessage(Message message) async {
    final url = 'https://fish-mgs.firebaseio.com/messages.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'message': message.message,
          'timestamp': message.timestamp,
          'userId': message.userId,
          'chatId': message.chatId,
        }),
      );
      final newMessage = Message(
        message: message.message,
        timestamp: message.timestamp,
        userId: message.userId,
        chatId: message.chatId,
        id: json.decode(response.body)['name'],
      );
      _items.add(newMessage);
      // _items.insert(0, newMessage); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMessage(String id, Message newMessage) async {
    final messageIndex = _items.indexWhere((message) => message.id == id);
    if (messageIndex >= 0) {
      final url = 'https://fish-mgs.firebaseio.com/messages/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'message': newMessage.message,
            'timestamp': newMessage.timestamp,
            'userId': newMessage.userId,
            'chatId': newMessage.chatId,
          }));
      _items[messageIndex] = newMessage;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteMessage(String id) async {
    final url = 'https://fish-mgs.firebaseio.com/messages/$id.json?auth=$authToken';
    final existingMessageIndex = _items.indexWhere((message) => message.id == id);
    var existingMessage = _items[existingMessageIndex];
    _items.removeAt(existingMessageIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingMessageIndex, existingMessage);
      notifyListeners();
      // throw HttpException('Could not delete product.');
    }
    existingMessage = null;
  }

}
