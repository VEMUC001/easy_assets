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

  final assetDirs = <String>[];

  // Add asset directories from pubspec.yaml
  if (pubspec['flutter'] != null && pubspec['flutter']['assets'] != null) {
    assetDirs.addAll((pubspec['flutter']['assets'] as List).cast<String>());
  }

  // Add font directories from pubspec.yaml
  if (pubspec['flutter'] != null && pubspec['flutter']['fonts'] != null) {
    for (final font in pubspec['flutter']['fonts']) {
      if (font['asset'] != null) {
        final fontPath = path.dirname(font['asset'] as String);
        if (!assetDirs.contains(fontPath)) {
          assetDirs.add(fontPath);
        }
      }
    }
  }

  // If no asset directories are specified, use the default 'assets' directory
  if (assetDirs.isEmpty) {
    assetDirs.add('assets');
  }

  final generator = AssetGenerator(
    projectRoot: projectDir,
    assetDirs: assetDirs,
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
