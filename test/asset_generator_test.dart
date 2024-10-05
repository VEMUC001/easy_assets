import 'package:test/test.dart';
import 'package:easy_assets/src/asset_generator.dart';

void main() {
  group('AssetGenerator', () {
    late AssetGenerator generator;

    setUp(() {
      generator = AssetGenerator(
        projectRoot: '/test/project',
        assetPaths: [
          'assets/images/logo.png',
          'assets/fonts/OpenSans-Regular.ttf',
          'lib/data/config.json',
        ],
        outputPath: 'lib/generated/assets.dart',
      );
    });

    test('generateAssetClass generates correct class', () async {
      final result = await generator.generateAssetClass();
      expect(result, contains('class Assets {'));
      expect(
          result,
          contains(
              "static const String imagesLogo = 'assets/images/logo.png';"));
      expect(
          result,
          contains(
              "static const String fontsOpensansRegular = 'assets/fonts/OpenSans-Regular.ttf';"));
      expect(
          result,
          contains(
              "static const String libDataConfig = 'lib/data/config.json';"));
      expect(result, contains('}'));
    });

    test('_sanitizeAssetName handles various input correctly', () {
      expect(generator.sanitizeAssetName('assets/images/logo.png'),
          equals('imagesLogo'));
      expect(generator.sanitizeAssetName('assets/fonts/OpenSans-Regular.ttf'),
          equals('fontsOpensansRegular'));
      expect(generator.sanitizeAssetName('lib/data/config.json'),
          equals('libDataConfig'));
      expect(generator.sanitizeAssetName('assets/images/background image.jpg'),
          equals('imagesBackgroundImage'));
    });
  });

  test('StringExtension capitalize works correctly', () {
    expect('hello'.capitalize(), equals('Hello'));
    expect('a'.capitalize(), equals('A'));
  });
}
