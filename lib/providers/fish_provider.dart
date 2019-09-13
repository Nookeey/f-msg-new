import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/fish.dart';

class FishProvider with ChangeNotifier {
  List<Fish> _items = [];

  List<Fish> get items {
    return [..._items];
  }

  final String authToken;

  FishProvider(this.authToken, this._items);

  Fish findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetFish() async {
    final url = 'https://fish-mgs.firebaseio.com/fish.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Fish> loadedFish = [];
      extractedData.forEach((fishId, fishData) {
        loadedFish.add(Fish(
          id: fishId,
          name: fishData['name'],
          description: fishData['description'],
          image: fishData['image'],
        ));
      });
      _items = loadedFish;
      notifyListeners();
    } catch (error) {
      // throw (error);
    }
  }

   Future<void> addFish(Fish fish) async {
    const url = 'https://fish-mgs.firebaseio.com/fish.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': fish.name,
          'description': fish.description,
          'image': fish.image,
        }),
      );
      final newFish = Fish(
        name: fish.name,
        description: fish.description,
        image: fish.image,
        id: json.decode(response.body)['name'],
      );
      _items.add(newFish);
      // _items.insert(0, newFish); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateFish(String id, Fish newFish) async {
    final fishIndex = _items.indexWhere((fish) => fish.id == id);
    if (fishIndex >= 0) {
      final url = 'https://fish-mgs.firebaseio.com/fish/$id.json';
      await http.patch(url,
          body: json.encode({
            'name': newFish.name,
            'description': newFish.description,
            'image': newFish.image,
          }));
      _items[fishIndex] = newFish;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteFish(String id) async {
    final url = 'https://fish-mgs.firebaseio.com/fish/$id.json';
    final existingFishIndex = _items.indexWhere((fish) => fish.id == id);
    var existingFish = _items[existingFishIndex];
    _items.removeAt(existingFishIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingFishIndex, existingFish);
      notifyListeners();
      // throw HttpException('Could not delete product.');
    }
    existingFish = null;
  }

}
