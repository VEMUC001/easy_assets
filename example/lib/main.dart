import 'package:flutter/material.dart';
import 'package:easy_assets/easy_assets.dart';
import 'generated/assets.dart'; // This will be generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Preload assets
  await AssetLoader().preloadAssets([
    "",
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyAssets Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'OpenSans',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyAssets Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "",
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              'This image was loaded using EasyAssets',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
