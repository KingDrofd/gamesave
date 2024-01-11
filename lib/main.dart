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
      debugShowCheckedModeBanner: false,
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
  late Future<List<Map<String, dynamic>>> jsonDataFuture;

  @override
  void initState() {
    jsonDataFuture = readJsonFile();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: const Color.fromARGB(255, 36, 36, 36),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.file_upload,
              color: Colors.grey,
              size: 40,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.file_download,
              color: Colors.grey,
              size: 40,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: jsonDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            List<Map<String, dynamic>> jsonData = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: GridView.builder(
                itemCount: jsonData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 200 / 100,
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  if (index < jsonData.length) {
                    return GameInfoCard(jsonData: jsonData, index: index);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            );
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          '${jsonData[index]['image_link']}',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Placeholder(),
                Text(
                  "No Image",
                  style: TextStyle(fontSize: 30),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
