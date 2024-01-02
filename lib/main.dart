import 'package:flutter/material.dart';
import 'package:gamesave/utils/directory_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String path = "";
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {
    path = await directories.getDocumentsPaths();
    directories.listDrives();
  }

  Directories directories = Directories();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          initialize();
        });
      }),
      body: Center(
        child: Text("$path"),
      ),
    );
  }
}
