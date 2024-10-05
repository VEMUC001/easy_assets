import 'dart:io';
import 'package:easy_assets/src/asset_generator.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

void main(List<String> args) async {
  final projectDir = Directory.current.path;
  final pubspecFile = File(path.join(projectDir, 'pubspec.yaml'));

  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found in the current directory.');
    exit(1);
  }

  final pubspecContent = await pubspecFile.readAsString();
  final pubspec = loadYaml(pubspecContent);

  final assetPaths = <String>[];

  // Add asset directories from pubspec.yaml
  if (pubspec['flutter'] != null && pubspec['flutter']['assets'] != null) {
    for (final asset in pubspec['flutter']['assets']) {
      final assetPath = asset as String;
      if (await FileSystemEntity.isDirectory(
          path.join(projectDir, assetPath))) {
        await _addAssetsFromDirectory(projectDir, assetPath, assetPaths);
      } else {
        assetPaths.add(assetPath);
      }
    }
  }

  // Add font assets from pubspec.yaml
  if (pubspec['flutter'] != null && pubspec['flutter']['fonts'] != null) {
    for (final font in pubspec['flutter']['fonts']) {
      if (font['family'] != null && font['fonts'] != null) {
        for (final fontFile in font['fonts']) {
          if (fontFile['asset'] != null) {
            assetPaths.add(fontFile['asset'] as String);
          }
        }
      }
    }
  }

  final generator = AssetGenerator(
    projectRoot: projectDir,
    assetPaths: assetPaths,
    outputPath: 'lib/generated/assets.dart',
  );

  try {
    final assetClass = await generator.generateAssetClass();
    final outputFile =
        File(path.join(projectDir, 'lib', 'generated', 'assets.dart'));
    await outputFile.create(recursive: true);
    await outputFile.writeAsString(assetClass);
    print('Assets generated successfully at ${outputFile.path}');
  } catch (e) {
    print('Error generating assets: $e');
    exit(1);
  }
}

Future<void> _addAssetsFromDirectory(
    String projectRoot, String dirPath, List<String> assetPaths) async {
  final dir = Directory(path.join(projectRoot, dirPath));
  await for (final entity in dir.list(recursive: true)) {
    if (entity is File) {
      final relativePath = path.relative(entity.path, from: projectRoot);
      assetPaths.add(relativePath);
    }
  }
}
