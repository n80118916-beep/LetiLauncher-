import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // Для использования Provider
import 'package:file_picker/file_picker.dart'; // Для выбора папок
import 'package:path_provider/path_provider.dart'; // Для системных путей
import 'dart:io'; // Для работы с файлами

// Модели и сервисы (предполагаем, что они будут созданы)
import '../models/minecraft_version.dart';
import '../services/minecraft_service.dart';
// import '../services/settings_service.dart'; // Если нужен будет доступ к настройкам

class VersionManagerScreen extends StatefulWidget {
  @override
  _VersionManagerScreenState createState() => _VersionManagerScreenState();
}

class _VersionManagerScreenState extends State<VersionManagerScreen> {
  // Список версий, которые мы загрузим из сервиса
  List<MinecraftVersion> _versions = [];
  MinecraftVersion? _activeVersion; // Активно выбранная версия
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadVersions();
  }

  // Загрузка списка версий
  Future<void> _loadVersions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      // Здесь будет логика загрузки версий.
      // Пока что используем заглушку. Позже будем использовать MinecraftService.
      // Предполагаем, что MinecraftService будет возвращать список версий.
      // _versions = await Provider.of<MinecraftService>(context, listen: false).getVersions();

      // Заглушка для примера
      await Future.delayed(Duration(seconds: 1)); // Имитация загрузки
      _versions = [
        MinecraftVersion(
          id: '1.20.1',
          type: 'release',
          folderPath: '/path/to/minecraft/1.20.1', // Пример пути
          jvmArgs: '-Xmx2G -Xms1G',
          isLocal: true, // Эта версия установлена локально
        ),
        MinecraftVersion(
          id: '1.12.2',
          type: 'release',
          folderPath: '/path/to/minecraft/1.12.2',
          jvmArgs: '-Xmx4G -Xms2G',
          isLocal: true,
        ),
        MinecraftVersion(
          id: '1.7.10',
          type: 'release',
          folderPath: '/path/to/minecraft/1.7.10',
          jvmArgs: '-Xmx4G -Xms2G',
          isLocal: true,
        ),
      ];

      // Установка активной версии (например, первая из списка)
      if (_versions.isNotEmpty) {
        _activeVersion = _versions.first;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Не удалось загрузить версии: ${e.toString()}';
      });
    }
  }

  // Функция выбора папки для новой версии
  Future<void> _addLocalVersion() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Выберите папку с версией Minecraft",
      lockParentWindow: true,
    );

    if (selectedDirectory != null) {
      // Здесь будет логика добавления новой локальной версии.
      // Нужно будет определить ID версии по файлам (например, client.jar, version.json)
      // Пока что просто добавим заглушку в список
      setState(() {
        _versions.add(MinecraftVersion(
          id: 'Custom ${DateTime.now().millisecondsSinceEpoch}',
          type: 'custom',
          folderPath: selectedDirectory,
          jvmArgs: '-Xmx2G -Xms1G', // Аргументы по умолчанию
          isLocal: true,
        ));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Версия добавлена. Пожалуйста, настройте ее.')),
      );
    }
  }

  // Функция для выбора активной версии
  void _setActiveVersion(MinecraftVersion version) {
    setState(() {
      _activeVersion = version;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Активная версия: ${version.id}')),
    );
    // Здесь можно сохранить активную версию в shared_preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Управление Версиями'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addLocalVersion, // Кнопка добавления локальной версии
            tooltip: 'Добавить локальную версию',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadVersions, // Кнопка обновления списка
            tooltip: 'Обновить список',
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Активная версия:',
                            style: GoogleFonts.russoOne(fontSize: 18, color: Colors.white70),
                          ),
                          SizedBox(height: 8),
                          // Карточка активной версии
                          if (_activeVersion != null)
                            _buildVersionCard(_activeVersion!, true)
                          else
                            Text('Версия не выбрана', style: GoogleFonts.russoOne(fontSize: 16, color: Colors.white54)),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Реализовать запуск игры
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Запуск игры... (функция в разработке)')),
                              );
                            },
                            child: Text('ИГРАТЬ'),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Theme.of(context).colorScheme.surface, height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _versions.length,
                        itemBuilder: (context, index) {
                          final version = _versions[index];
                          // Не показываем активную версию в списке, если она уже выбрана
                          if (version.id == _activeVersion?.id && version.isLocal == _activeVersion?.isLocal) {
                            return SizedBox.shrink();
                          }
                          return _buildVersionCard(version, false);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  // Виджет для отображения карточки версии
  Widget _buildVersionCard(MinecraftVersion version, bool isActive) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: isActive
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.2) // Подсветка активной версии
          : Theme.of(context).colorScheme.surface, // Цвет обычной карточки
      elevation: isActive ? 6.0 : 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  version.id,
                  style: GoogleFonts.russoOne(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  'Тип: ${version.type}',
                  style: GoogleFonts.russoOne(fontSize: 14, color: Colors.white54),
                ),
                SizedBox(height: 4),
                Text(
                  'Путь: ${version.folderPath}',
                  style: GoogleFonts.russoOne(fontSize: 12, color: Colors.white38),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Row(
              children: [
                if (!isActive)
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () => _setActiveVersion(version),
                    tooltip: 'Сделать активной',
                  ),
                if (version.type == 'custom' || version.type == 'local') // Можно добавить кнопку удаления для локальных версий
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () {
                      // TODO: Добавить удаление локальной версии
                      setState(() {
                        _versions.remove(version);
                        if (_activeVersion == version) {
                          _activeVersion = null; // Сбрасываем активную, если удалили ее
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Версия удалена')),
                      );
                    },
                    tooltip: 'Удалить версию',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
