import 'dart:io';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _directoryPathController = TextEditingController();
  List<String> lastSegments = [];

  void _checkDirectory() {
    String basePath = _directoryPathController.text;

    Directory baseDirectory = Directory(basePath);
    if (baseDirectory.existsSync()) {
      List<Directory> subdirectories = baseDirectory
          .listSync()
          .where((entity) => entity is Directory)
          .cast<Directory>()
          .toList();

      lastSegments = subdirectories.map((subdirectory) {
        List<String> pathSegments =
            subdirectory.path.split(Platform.pathSeparator);
        return pathSegments.isNotEmpty ? pathSegments.last : '';
      }).toList();
    } else {
      lastSegments.clear();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directory Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _directoryPathController,
              decoration: InputDecoration(labelText: 'Enter directory path'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkDirectory,
              child: Text('Check Directory'),
            ),
            SizedBox(height: 20),
            Text('Last segments of subdirectories:'),
            Expanded(
              child: ListView.builder(
                itemCount: lastSegments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: SelectableText(lastSegments[index]),
                    onTap: () {
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
