import '../../models/clothing_item_model.dart';

class RecommendationService {

  List<ClothingItemModel> recommend({
    required List<ClothingItemModel> wardrobe,
    required String weather,
    required String style,
  }) {

    List<ClothingItemModel> result = [];

    for (var item in wardrobe) {

      if (weather == "cold" &&
          item.category.toLowerCase() == "jacket") {
        result.add(item);
      }

      if (style == "casual" &&
          item.category.toLowerCase() == "tshirt") {
        result.add(item);
      }
    }

    return result;
  }
}