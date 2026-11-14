import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/minecraft_service.dart';
// import '../services/mod_service.dart'; // Будет нужен для работы с модами

class ModBrowserScreen extends StatefulWidget {
  @override
  _ModBrowserScreenState createState() => _ModBrowserScreenState();
}

class _ModBrowserScreenState extends State<ModBrowserScreen> {
  late MinecraftService _minecraftService;
  // late ModService _modService; // TODO: Нужен будет сервис для модов

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minecraftService = Provider.of<MinecraftService>(context, listen: false);
    // _modService = Provider.of<ModService>(context, listen: false); // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Моды'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // TODO: Реализовать поиск модов
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Реализовать фильтрацию модов
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 50, color: Colors.white38),
            SizedBox(height: 16),
            Text(
              'Магазин модов (в разработке)',
              style: GoogleFonts.russoOne(fontSize: 20, color: Colors.white54),
            ),
            SizedBox(height: 16),
            Text(
              'Здесь вы сможете искать и устанавливать моды для ваших версий Minecraft.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white38),
            ),
            SizedBox(height: 24),
            // TODO: Добавить кнопку для ручного добавления модов
            // ElevatedButton(
            //   onPressed: () { /* TODO: Открыть FilePicker */ },
            //   child: Text('Добавить мод вручную'),
            // ),
          ],
        ),
      ),
    );
  }
}
