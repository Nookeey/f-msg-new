import 'package:flutter/material.dart';

class Chat {
  final String id;
  final String image;
  final String name;
  final String message;
  final String owner;

  Chat({
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.message,
    @required this.owner,
  });
}
