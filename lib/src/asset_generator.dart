import 'package:path/path.dart' as path;

class AssetGenerator {
  final String projectRoot;
  final List<String> assetPaths;
  final String outputPath;

  AssetGenerator({
    required this.projectRoot,
    required this.assetPaths,
    this.outputPath = 'lib/generated/assets.dart',
  });

  Future<String> generateAssetClass() async {
    return _generateAssetClass(assetPaths);
  }

  String _generateAssetClass(List<String> assetPaths) {
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('class Assets {');

    for (final assetPath in assetPaths) {
      final sanitizedName = sanitizeAssetName(assetPath);
      buffer.writeln('  static const String $sanitizedName = \'$assetPath\';');
    }

    buffer.writeln('}');
    return buffer.toString();
  }

  String sanitizeAssetName(String assetPath) {
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
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
