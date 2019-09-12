import 'package:flutter/material.dart';

class Fish {
  final String id;
  final String name;
  final String description;
  final String image;

  Fish({
    this.id,
    @required this.name,
    @required this.description,
    @required this.image
  });
}
