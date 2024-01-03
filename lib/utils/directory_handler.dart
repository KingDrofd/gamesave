import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Directories {
  Future<String> getDocumentsPaths() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();

    return documentsDir.path;
  }

  List<String> listFolders(String parentFolder) {
    Directory _parentFolder = Directory('$parentFolder/');
    List<FileSystemEntity> drives = _parentFolder.listSync();

    List<String> folderPaths = [];
    for (var drive in drives) {
      folderPaths.add(drive.uri.path);
    }
    print('Folders in $parentFolder: \n $folderPaths');
    return folderPaths;
  }

  String getProgramFiles() {
    Directory root = Directory('/');

    return root.path;
  }

  Future<bool> doesFolderExist(String folderName) async {
    Directory folder = Directory('${getProgramFiles()}$folderName');

    return folder.exists();
  }
}
