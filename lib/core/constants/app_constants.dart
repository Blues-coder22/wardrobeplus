class AppConstants {
  AppConstants._();

  // App info
  static const appName         = 'Wardrobe+';
  static const appVersion      = '1.0.0';

  // Weather API — replace with your OpenWeatherMap key
  static const weatherApiKey   = 'YOUR_OPENWEATHER_API_KEY';
  static const weatherBaseUrl  = 'https://api.openweathermap.org/data/2.5';
  static const defaultCity     = 'Nairobi';
  static const defaultLat      = -1.2921;
  static const defaultLon      = 36.8219;

  // AI service — replace with your backend or direct API key
  static const aiBaseUrl       = 'https://your-ai-backend.com/api';

  // Free tier limits
  static const freeClosetLimit = 15;
  static const freePlannerDays = 7;
  static const freeChatMessages = 10;

  // Animation durations (ms)
  static const animFast   = 200;
  static const animNormal = 350;
  static const animSlow   = 600;
}

