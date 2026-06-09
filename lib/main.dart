import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/route_constants.dart';
import 'providers/auth_provider.dart';
import 'router/app_router.dart';
import 'services/auth/firebase_auth_service.dart';
import 'services/storage/local_storage_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCbdhqqd7f0kUGSTathhZIsMsgeaFjrr70",
      appId: "1:1004565969193:android:0a737f35ed48494db31f38",
      messagingSenderId: "1004565969193",
      projectId: "wardrobeplus-b30d3",
      storageBucket: "wardrobeplus-b30d3.firebasestorage.app",
    ),
  );
  
  await LocalStorageService.init();
  
  // Lock orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(const WardrobePlusApp());
}

class WardrobePlusApp extends StatelessWidget {
  const WardrobePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(FirebaseAuthService()),
        ),
      ],
      child: MaterialApp(
        title: 'Wardrobe+',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Routes.splash,
      ),
    );
  }
}
