import 'dart:io';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:easy_assets/src/asset_generator.dart';

// Mock classes
class MockFile extends Mock implements File {}

class MockDirectory extends Mock implements Directory {}

class MockFileSystemEntity extends Mock implements FileSystemEntity {}

void main() {
  group('easy_assets_generator', () {
    late MockFile mockPubspecFile;
    late MockDirectory mockDirectory;
    late MockFileSystemEntity mockFileSystemEntity;

    setUp(() {
      mockPubspecFile = MockFile();
      mockDirectory = MockDirectory();
      mockFileSystemEntity = MockFileSystemEntity();

      // Set up default behaviors
      when(() => mockPubspecFile.existsSync()).thenReturn(true);
      when(() => mockPubspecFile.readAsString()).thenAnswer((_) async => '''
flutter:
  assets:
    - assets/images/
    - assets/fonts/font.ttf
  fonts:
    - family: OpenSans
      fonts:
        - asset: assets/fonts/OpenSans-Regular.ttf
''');
    });

    test('main function processes pubspec.yaml correctly', () async {
      // Mock Directory.current
      Directory.current = Directory('/test/project');

      // Mock FileSystemEntity.isDirectory
      when(() => FileSystemEntity.isDirectory(any()))
          .thenAnswer((_) async => true);

      // Mock Directory listing
      when(() => mockDirectory.list(recursive: true)).thenAnswer((_) async* {
        yield File('/test/project/assets/images/logo.png');
        yield File('/test/project/assets/fonts/font.ttf');
      });

      // Run the main function (you'll need to extract the logic from bin/easy_assets_generator.dart into a separate function for testing)
      await runEasyAssetsGenerator();

      // Verify that the asset generator was called with the correct paths
      verify(() => AssetGenerator(
            projectRoot: '/test/project',
            assetPaths: [
              'assets/images/logo.png',
              'assets/fonts/font.ttf',
              'assets/fonts/OpenSans-Regular.ttf',
            ],
            outputPath: 'lib/generated/assets.dart',
          ).generateAssetClass()).called(1);
    });

    // Add more tests to cover different scenarios and edge cases
  });
}

// Extract the main logic from bin/easy_assets_generator.dart into this function
Future<void> runEasyAssetsGenerator() async {
  // Paste the contents of the main function here,
  // replacing File and Directory instantiations with the mock versions
}
