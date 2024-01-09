import 'dart:convert';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gamesave/utils/directory_handler.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Directories directories = Directories();
  List<Map<String, dynamic>> jsonData = [];

  @override
  void initState() {
    loadJsonData();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> readJsonFile() async {
    try {
      String documentDir = await directories.getDocumentsPaths();
      String filePath = '$documentDir/steam_app_info.json';
      File file = File(filePath);
      String fileContent = await file.readAsString();

      final jsonData = jsonDecode(fileContent);
      final data = jsonData['applist']['apps'];

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> loadJsonData() async {
    List<Map<String, dynamic>> data = await readJsonFile();

    setState(() {
      jsonData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // You can adjust the cross-axis count as needed
        ),
        itemBuilder: (context, index) {
          if (index < jsonData.length) {
            return GameInfoCard(
              jsonData: jsonData,
              index: index,
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class GameInfoCard extends StatelessWidget {
  const GameInfoCard({
    super.key,
    required this.jsonData,
    required this.index,
  });

  final List<Map<String, dynamic>> jsonData;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image.network(
            '${jsonData[index]['image_link']}',
            errorBuilder: (context, error, stackTrace) {
              return Text("No Image");
            },
          ),
          Gap(10),
          Text('${jsonData[index]["name"]}'),
          Text('Id: ${jsonData[index]["appid"]}'),
          Text('Location: ${jsonData[index]["directory"]}'),
        ],
      ),
    );
  }
}
