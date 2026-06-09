import '../../models/body_type_model.dart';
import '../../models/style_option_model.dart';

class AIStylistService {
  Future<List<String>> generateRecommendations({
    required BodyTypeOption bodyType,
    required StyleOption style,
    required String gender,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    List<String> suggestions = [];

    // Base recommendation on body type
    suggestions.add(bodyType.stylingTip);

    // Style-specific recommendations
    switch (style.id) {
      case 'minimalist':
        suggestions.add("Monochromatic neutrals (White/Grey/Black)");
        suggestions.add("Clean-cut basic tees and tailored trousers");
        break;

      case 'streetwear':
        suggestions.add("Oversized hoodies or graphic tees");
        suggestions.add("Cargo pants or relaxed fit denim");
        break;

      case 'vintage':
        suggestions.add("Tweed blazers or knit vests");
        suggestions.add("Pleated trousers or corduroy items");
        break;

      case 'techwear':
        suggestions.add("Waterproof shell jackets");
        suggestions.add("Tapered joggers with utility straps");
        break;

      case 'afro-chic':
        suggestions.add("Vibrant Ankara prints or mudcloth details");
        suggestions.add("Statement jewelry and bold patterns");
        break;

      case 'business':
        suggestions.add("Tailored blazers or crisp dress shirts");
        suggestions.add("Chinos or formal trousers in navy/charcoal");
        break;

      default:
        suggestions.add("Smart casual versatile outfit");
    }

    return suggestions;
  }
}
