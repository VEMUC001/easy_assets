# EasyAssets

EasyAssets is a Flutter package that simplifies asset management by automatically generating a Dart class with references to your assets. It scans your project's asset directories and creates type-safe constants for easy access to your images, fonts, and other resources.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Automatically generates a Dart class with constants for all your assets
- Supports images, fonts, and other asset types
- Customizable asset directories
- Generates camelCase naming for easy access
- Integrates seamlessly with your existing Flutter project

## Installation

Add EasyAssets to your `pubspec.yaml` file:

```yaml
dev_dependencies:
  easy_assets: ^1.0.0
```

Run `flutter pub get` to install the package.

## Usage

### Basic Usage

1. Run the asset generator:

   ```
   flutter pub run easy_assets:easy_assets_generator
   ```

   This will scan your asset directories and generate an `assets.dart` file in `lib/generated/`.

2. Import the generated file in your Dart code:

   ```dart
   import 'package:your_project/generated/assets.dart';
   ```

3. Use the generated constants to access your assets:

   ```dart
   Image.asset(Assets.imagesLogo)
   ```

### Configuration

EasyAssets uses your `pubspec.yaml` file to determine which directories to scan. Make sure your assets are properly declared in the `flutter` section of your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/fonts/
  fonts:
    - family: OpenSans
      fonts:
        - asset: assets/fonts/OpenSans-Regular.ttf
        - asset: assets/fonts/OpenSans-Bold.ttf
          weight: 700
```

### Customizing Asset Generation

You can customize the asset generation process by modifying the `easy_assets_generator.dart` file. See the [Customization](#customization) section for more details.

## Examples

### Accessing Images

```dart
Image.asset(Assets.imagesLogo)
```

### Using Fonts

```dart
Text(
  'Hello, World!',
  style: TextStyle(fontFamily: 'OpenSans'),
)
```

### Accessing Other Asset Types

```dart
String jsonData = await rootBundle.loadString(Assets.dataConfig);
```

## Customization

To customize the asset generation process:

1. Copy the `bin/easy_assets_generator.dart` file from the package to your project.
2. Modify the copied file to suit your needs (e.g., changing naming conventions, output location).
3. Run the customized generator:

   ```
   flutter pub run bin/easy_assets_generator.dart
   ```

## Best Practices

- Run the asset generator whenever you add, remove, or rename assets.
- Consider adding the asset generation step to your build process or CI/CD pipeline.
- Keep your asset directory structure organized and consistent.

## Troubleshooting

If you encounter any issues:

- Ensure your `pubspec.yaml` file correctly declares all your asset directories.
- Check that the generated `assets.dart` file is up to date with your current asset structure.
- If using a custom generator, make sure it's properly configured for your project structure.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Thanks to all the contributors who have helped to improve this package.
- Inspired by the need for simpler asset management in Flutter projects.