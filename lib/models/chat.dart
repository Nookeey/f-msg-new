import 'package:flutter/material.dart';

class Chat {
  final String id;
  final String avatar;
  final String name;
  final String owner;
  final bool hasAcces;

  Chat({
    @required this.id,
    this.avatar,
    @required this.name,
    @required this.owner,
    this.hasAcces,
  });
}
