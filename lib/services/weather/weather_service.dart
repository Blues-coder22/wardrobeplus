class WeatherService {
  Future<String> getWeatherSuggestion(double temp) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (temp < 15) {
      return "Wear a jacket";
    }

    if (temp < 25) {
      return "Light sweater recommended";
    }

    return "Lightweight clothing recommended";
  }
}