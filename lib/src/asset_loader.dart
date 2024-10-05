import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class AssetLoader {
  static final AssetLoader _instance = AssetLoader._internal();
  factory AssetLoader() => _instance;
  AssetLoader._internal();

  final Map<String, Uint8List> _cachedAssets = {};
  final Set<String> _loadingAssets = {};

  /// Returns the path for the given asset name.
  String getAssetPath(String assetName) => assetName;

  /// Preloads the specified assets into memory.
  ///
  /// This can be useful for improving performance when loading frequently used assets.
  Future<void> preloadAssets(List<String> assetNames) async {
    final futures =
        assetNames.map((assetName) => _loadAndCacheAsset(assetName));
    await Future.wait(futures);
  }

  /// Retrieves the preloaded asset data.
  ///
  /// Returns null if the asset hasn't been preloaded.
  Future<Uint8List?> getPreloadedAsset(String assetName) async {
    if (_cachedAssets.containsKey(assetName)) {
      return _cachedAssets[assetName];
    } else if (!_loadingAssets.contains(assetName)) {
      return _loadAndCacheAsset(assetName);
    }
    // If the asset is currently loading, wait for it to complete
    while (_loadingAssets.contains(assetName)) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    return _cachedAssets[assetName];
  }

  /// Clears all preloaded assets from memory.
  void clearPreloadedAssets() {
    _cachedAssets.clear();
    _loadingAssets.clear();
  }

  Future<Uint8List?> _loadAndCacheAsset(String assetName) async {
    if (_loadingAssets.contains(assetName)) return null;
    _loadingAssets.add(assetName);
    try {
      final ByteData data = await rootBundle.load(assetName);
      final Uint8List bytes = data.buffer.asUint8List();
      _cachedAssets[assetName] = bytes;
      return bytes;
    } catch (e) {
      print('Failed to load asset: $assetName');
      return null;
    } finally {
      _loadingAssets.remove(assetName);
    }
  }
}
