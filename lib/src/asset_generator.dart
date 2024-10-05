import 'dart:io';
import 'package:path/path.dart' as path;

class AssetGenerator {
  final String projectRoot;
  final List<String> assetDirs;
  final String outputPath;

  AssetGenerator({
    required this.projectRoot,
    required this.assetDirs,
    this.outputPath = 'lib/generated/assets.dart',
  });

  Future<String> generateAssetClass() async {
    final assetPaths = await _scanAssets();
    return _generateAssetClass(assetPaths);
  }

  Future<List<String>> _scanAssets() async {
    final assetPaths = <String>[];
    for (final assetDir in assetDirs) {
      final fullAssetDir = path.join(projectRoot, assetDir);
      if (await Directory(fullAssetDir).exists()) {
        await for (final entity
            in Directory(fullAssetDir).list(recursive: true)) {
          if (entity is File) {
            final relativePath = path.relative(entity.path, from: projectRoot);
            assetPaths.add(relativePath);
          }
        }
      } else {
        print('Warning: Asset directory $fullAssetDir does not exist.');
      }
    }
    return assetPaths;
  }

  String _generateAssetClass(List<String> assetPaths) {
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('class Assets {');

    for (final assetPath in assetPaths) {
      final sanitizedName = _sanitizeAssetName(assetPath);
      buffer.writeln('  static const String $sanitizedName = \'$assetPath\';');
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  String _sanitizeAssetName(String assetPath) {
    final parts = path.split(assetPath);
    // Remove 'assets' from the beginning if it's there
    if (parts.first == 'assets') {
      parts.removeAt(0);
    }
    // Join the parts back together
    final withoutExtension = path.withoutExtension(parts.join('_'));
    final sanitized = withoutExtension
        .replaceAll(RegExp(r'[^\w\s]+'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();

    // Convert to camelCase
    final words = sanitized.split('_');
    return words.first +
        words.skip(1).map((word) => word.capitalize()).join('');
  }
}

// Extension method to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}