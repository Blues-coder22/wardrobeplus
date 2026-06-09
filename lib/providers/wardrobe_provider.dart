import 'package:flutter/material.dart';
import '../models/clothing_item_model.dart';

class WardrobeProvider with ChangeNotifier {
  final List<ClothingItemModel> _items = [];
  List<ClothingItemModel> get items => _items;

  void addItem(ClothingItemModel item) {
    _items.add(item);
    notifyListeners();
  }
}
