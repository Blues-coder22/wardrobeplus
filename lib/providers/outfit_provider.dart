import 'package:flutter/material.dart';
import '../models/outfit_model.dart';

class OutfitProvider with ChangeNotifier {
  final List<OutfitModel> _outfits = [];
  List<OutfitModel> get outfits => _outfits;
  
  void addOutfit(OutfitModel outfit) {
    _outfits.add(outfit);
    notifyListeners();
  }
}
