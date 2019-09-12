import 'package:flutter/material.dart';

class Message {
  final String id;
  final String message;
  final String timestamp;
  final String userId;
  final String chatId;

  Message({
    @required this.id,
    @required this.message,
    @required this.timestamp,
    @required this.userId,
    @required this.chatId,
  });
}
