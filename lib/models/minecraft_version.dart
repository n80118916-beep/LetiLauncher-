class MinecraftVersion {
  final String id;          // ID версии (например, "1.20.1")
  final String type;        // Тип версии (release, snapshot, custom, local)
  final String folderPath;  // Путь к папке с файлами игры (очень важно для "пиратки")
  final String? jvmArgs;    // JVM аргументы для запуска (например, "-Xmx2G")
  final bool isLocal;       // Является ли версия локальной (добавленной пользователем)
  // final String? minecraftJarPath; // Путь к client.jar (можно добавить, если нужно)
  // final String? versionJsonPath;  // Путь к version.json (можно добавить)

  MinecraftVersion({
    required this.id,
    required this.type,
    required this.folderPath,
    this.jvmArgs,
    this.isLocal = false, // По умолчанию не локальная
    // this.minecraftJarPath,
    // this.versionJsonPath,
  });

  // Можно добавить методы для сохранения/загрузки из JSON или Shared Preferences
  // Пример:
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'folderPath': folderPath,
        'jvmArgs': jvmArgs,
        'isLocal': isLocal,
      };

  factory MinecraftVersion.fromJson(Map<String, dynamic> json) => MinecraftVersion(
        id: json['id'],
        type: json['type'],
        folderPath: json['folderPath'],
        jvmArgs: json['jvmArgs'],
        isLocal: json['isLocal'] ?? false,
      );

  // Переопределение оператора равенства, чтобы сравнивать версии по ID и isLocal
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinecraftVersion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isLocal == other.isLocal; // Считаем локальные версии уникальными по ID

  @override
  int get hashCode => id.hashCode ^ isLocal.hashCode;
}
