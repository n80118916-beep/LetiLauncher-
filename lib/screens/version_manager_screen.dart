import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async'; // Для Timer

import '../models/minecraft_version.dart';
import '../services/minecraft_service.dart';

class VersionManagerScreen extends StatefulWidget {
  @override
  _VersionManagerScreenState createState() => _VersionManagerScreenState();
}

class _VersionManagerScreenState extends State<VersionManagerScreen> {
  late MinecraftService _minecraftService; // Получим сервис через Provider
  List<MinecraftVersion> _versions = [];
  MinecraftVersion? _activeVersion;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Инициализируем сервис здесь, но будем использовать его после того, как он будет доступен через Provider
    // _loadVersions(); // Перенесем в didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _minecraftService = Provider.of<MinecraftService>(context, listen: false);
    _loadVersions(); // Загружаем версии при первом изменении зависимостей
  }

  Future<void> _loadVersions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      _versions = await _minecraftService.getVersions();
      _activeVersion = await _minecraftService.getActiveVersion();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Ошибка загрузки версий: ${e.toString()}';
      });
    }
  }

  Future<void> _addLocalVersion() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "Выберите папку с версией Minecraft",
      lockParentWindow: true,
    );

    if (selectedDirectory != null) {
      try {
        // TODO: Реальная логика парсинга ID версии из папки
        // Пока что используем временный ID, но в будущем надо парсить version.json
        final versionId = await _detectVersionId(selectedDirectory); // Пытаемся определить ID

        await _minecraftService.addLocalVersion(selectedDirectory, versionId);
        await _loadVersions(); // Перезагружаем список версий
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Версия "$versionId" добавлена.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка добавления версии: ${e.toString()}')),
        );
      }
    }
  }

  // Примерная функция для определения ID версии из папки
  Future<String> _detectVersionId(String folderPath) async {
    final versionJsonFile = File('$folderPath/version.json');
    if (await versionJsonFile.exists()) {
      try {
        final jsonContent = await versionJsonFile.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(jsonContent);
        return jsonData['id'] ?? 'Unknown';
      } catch (e) {
        print("Error parsing version.json: $e");
        return 'Unknown (Error parsing)';
      }
    } else {
      // Если version.json нет, пробуем найти client.jar и извлечь ID из имени папки
      final clientJarFile = File('$folderPath/client.jar');
      if (await clientJarFile.exists()) {
        final folderName = folderPath.split('/').last;
        return folderName; // Используем имя папки как ID
      }
      return 'Unknown (No version.json/client.jar)';
    }
  }

  Future<void> _setActiveVersion(MinecraftVersion version) async {
    try {
      await _minecraftService.setActiveVersion(version);
      _activeVersion = version; // Обновляем состояние локально
      setState(() {}); // Обновляем UI
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Активная версия: ${version.id}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка установки версии: ${e.toString()}')),
      );
    }
  }

  Future<void> _removeVersion(MinecraftVersion version) async {
    if (!version.isLocal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Можно удалять только локальные версии.')),
      );
      return;
    }

    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтвердите удаление'),
          content: Text('Вы уверены, что хотите удалить локальную версию "${version.id}"? Это действие нельзя будет отменить.'),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Удалить', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await _minecraftService.removeLocalVersion(version);
        await _loadVersions(); // Перезагружаем список
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Версия "${version.id}" удалена.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления версии: ${e.toString()}')),
        );
      }
    }
  }

  // TODO: Реализация запуска игры
  Future<void> _launchGame() async {
    if (_activeVersion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выберите активную версию игры.')),
      );
      return;
    }

    // Здесь будет сложная логика:
    // 1. Проверить наличие необходимых файлов (client.jar, version.json, libraries).
    // 2. Парсить version.json для получения JVM аргументов, путей к библиотекам.
    // 3. Получить никнейм пользователя (нужно добавить поле ввода в UI).
    // 4. Сконструировать команду для запуска JVM (например, с помощью `Process.start` или `url_launcher` для перехода в другое приложение, если лаунчер не может сам запускать JVM).
    // 5. Реализовать офлайн-режим (online-mode=false).

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запуск игры "${_activeVersion!.id}"... (функция в разработке)')),
    );
    // Пока что ничего не делаем
  }


  @override
  Widget build(BuildContext context) {
    // Убираем AppBar, т.к. он есть в HomeScreen
    return Scaffold(
      // appBar: AppBar( ... ), // AppBar будет в HomeScreen
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
                          if (_activeVersion != null)
                            _buildVersionCard(_activeVersion!, true)
                          else
                            Card(
                              color: Theme.of(context).colorScheme.surface,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Версия не выбрана', style: GoogleFonts.russoOne(fontSize: 16, color: Colors.white54)),
                              ),
                            ),
                          SizedBox(height: 16),
                          // TODO: Добавить поле для ввода никнейма
                          // TextField(...)
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _activeVersion == null ? null : _launchGame, // Кнопка активна, если выбрана версия
                            child: Text('ИГРАТЬ'),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Theme.of(context).colorScheme.surface, height: 1),
                    Expanded(
                      child: _versions.isEmpty && !_isLoading
                          ? Center(child: Text('Версии не найдены. Добавьте новую.'))
                          : ListView.builder(
                              itemCount: _versions.length,
                              itemBuilder: (context, index) {
                                final version = _versions[index];
                                // Не показываем активную версию в списке, если она уже выбрана
                                if (_activeVersion != null && _activeVersion == version) {
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

  Widget _buildVersionCard(MinecraftVersion version, bool isActive) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: isActive
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
          : Theme.of(context).colorScheme.surface,
      elevation: isActive ? 6.0 : 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( // Оборачиваем в Expanded, чтобы текст не выходил за пределы
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    version.id,
                    style: GoogleFonts.russoOne(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
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
            ),
            Row(
              mainAxisSize: MainAxisSize.min, // Занимаем минимальное место
              children: [
                if (!isActive)
                  IconButton(
                    icon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.secondary),
                    onPressed: () => _setActiveVersion(version),
                    tooltip: 'Сделать активной',
                  ),
                if (version.isLocal)
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => _removeVersion(version),
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
