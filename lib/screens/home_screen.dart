import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Для SVG иконок

// Импорт других экранов
import 'version_manager_screen.dart';
import 'mod_browser_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Индекс текущего выбранного элемента навигации

  // Список виджетов для каждого экрана навигации
  static List<Widget> _widgetOptions = <Widget>[
    // Placeholder для основного экрана (где будет кнопка "Играть" и выбор версии)
    Center(
      child: Text(
        'Главная страница LetiLauncher',
        style: TextStyle(fontSize: 24, color: Colors.white70),
      ),
    ),
    VersionManagerScreen(), // Экран управления версиями
    ModBrowserScreen(),     // Экран браузера модов
    // Placeholder для настроек
    Center(
      child: Text(
        'Настройки',
        style: TextStyle(fontSize: 24, color: Colors.white70),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип (можно заменить на SVG или картинку)
            // SvgPicture.asset('assets/images/launcher_logo.svg', height: 30),
            // SizedBox(width: 8),
            Text(
              'LetiLauncher',
              style: GoogleFonts.russoOne( // Используем заданный шрифт
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () {
        //       // Навигация на экран настроек или открытие диалога
        //       _onItemTapped(3); // Переход на экран настроек
        //     },
        //   ),
        // ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
            activeIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.secondary),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/version_icon.svg', height: 24, colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn)), // Пример SVG иконки
            activeIcon: SvgPicture.asset('assets/icons/version_icon.svg', height: 24, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.secondary, BlendMode.srcIn)),
            label: 'Версии',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/mod_icon.svg', height: 24, colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn)), // Пример SVG иконки
            activeIcon: SvgPicture.asset('assets/icons/mod_icon.svg', height: 24, colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.secondary, BlendMode.srcIn)),
            label: 'Моды',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
            activeIcon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary, // Цвет активного элемента
        unselectedItemColor: Colors.white54, // Цвет неактивных элементов
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface, // Цвет фона навигации
        type: BottomNavigationBarType.fixed, // Фиксированное отображение элементов
      ),
    );
  }
}

// Placeholder для VersionManagerScreen (будет создан позже)
class VersionManagerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 50, color: Colors.white38),
          SizedBox(height: 16),
          Text(
            'Управление Версиями (в разработке)',
            style: GoogleFonts.russoOne(fontSize: 20, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

// Placeholder для ModBrowserScreen (будет создан позже)
class ModBrowserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 50, color: Colors.white38),
          SizedBox(height: 16),
          Text(
            'Браузер Модов (в разработке)',
            style: GoogleFonts.russoOne(fontSize: 20, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
