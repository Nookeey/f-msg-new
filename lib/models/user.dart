import 'package:flutter/material.dart';

class User {
  final String id;
  final String email;
  final String password;
  final String avatar;
  final String nick;

  User({
    this.id,
    @required this.email,
    this.password,
    this.avatar,
    this.nick,
  });
}
