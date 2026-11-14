import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для SystemChrome
import 'package:google_fonts/google_fonts.dart'; // Импортируем Google Fonts
import 'package:provider/provider.dart'; // Если используете Provider

// Импорт ваших экранов
import 'screens/home_screen.dart';
// import 'screens/version_manager_screen.dart'; // Будем импортировать позже

// Импорт сервисов, если они нужны здесь
// import 'services/settings_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Убедиться, что Flutter инициализирован

  // Настройка ориентации экрана (если нужно)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Можно также настроить системные UI (например, убрать полоску уведомлений)
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    // Если используете Provider для управления состоянием
    // MultiProvider(
    //   providers: [
    //     // Provider<SettingsService>(create: (_) => SettingsService()),
    //     // Другие провайдеры...
    //   ],
    //   child: LetiLauncherApp(),
    // )

    // Если не используете Provider пока
    LetiLauncherApp(),
  );
}

class LetiLauncherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetiLauncher',
      theme: ThemeData(
        // Основная тема приложения
        primarySwatch: Colors.blueGrey, // Можно выбрать другой цвет
        primaryColor: Color(0xFF455A64), // Темно-сине-серый
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark, // Применяем темную тему
        ).copyWith(
          secondary: Color(0xFF00BCD4), // Бирюзовый акцент
          surface: Color(0xFF37474F), // Цвет поверхности (например, для карточек)
          background: Color(0xFF263238), // Цвет фона
        ),

        // Настройка шрифтов
        textTheme: GoogleFonts.russoOneTextTheme( // Используем шрифт из Google Fonts
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white70, // Цвет текста на темном фоне
          displayColor: Colors.white,
        ),

        // Стиль AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF37474F), // Цвет AppBar
          foregroundColor: Colors.white, // Цвет иконок и заголовка AppBar
          elevation: 4.0, // Тень под AppBar
          titleTextStyle: GoogleFonts.russoOne( // Шрифт для заголовка AppBar
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // Стиль кнопок
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF00BCD4), // Цвет кнопок
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: GoogleFonts.russoOne(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        // Стиль TextFormField (для ввода никнейма, поиска)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF374747), // Темный фон для полей ввода
          hintStyle: GoogleFonts.russoOne(color: Colors.white54),
          labelStyle: GoogleFonts.russoOne(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, // Убираем рамку, т.к. есть фон
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      debugShowCheckedModeBanner: false, // Убираем баннер "Debug"
      home: HomeScreen(), // Главный экран приложения
    );
  }
}
