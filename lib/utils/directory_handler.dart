import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Directories {
  Future<String> getDocumentsPaths() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();

    return documentsDir.path;
  }

  void listDrives() {
    Directory root = Directory('/');
    List<FileSystemEntity> drives = root.listSync();

    print('Available Drives:');
    for (var drive in drives) {
      print(drive.uri.path);
    }
  }
}
