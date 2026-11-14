import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Импортируем Provider

import 'screens/home_screen.dart';
// import 'screens/version_manager_screen.dart'; // Уже импортирован в HomeScreen
// import 'screens/mod_browser_screen.dart'; // Уже импортирован в HomeScreen

import 'services/minecraft_service.dart'; // Импортируем наш сервис

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // Оборачиваем MaterialApp в ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => MinecraftService(), // Создаем экземпляр нашего сервиса
      child: LetiLauncherApp(),
    ),
  );
}

class LetiLauncherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetiLauncher',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Color(0xFF455A64),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark,
        ).copyWith(
          secondary: Color(0xFF00BCD4), // Бирюзовый акцент
          surface: Color(0xFF37474F),
          background: Color(0xFF263238),
        ),
        textTheme: GoogleFonts.russoOneTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white70,
          displayColor: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF37474F),
          foregroundColor: Colors.white,
          elevation: 4.0,
          titleTextStyle: GoogleFonts.russoOne(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00BCD4),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: GoogleFonts.russoOne(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF374747),
          hintStyle: GoogleFonts.russoOne(color: Colors.white54),
          labelStyle: GoogleFonts.russoOne(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        // Тема для BottomNavigationBar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF37474F), // Цвет фона навигации
          selectedItemColor: Colors.cyanAccent, // Цвет активной иконки/текста
          unselectedItemColor: Colors.white54, // Цвет неактивной иконки/текста
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
