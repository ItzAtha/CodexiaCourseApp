import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  // Singleton pattern
  static final FirebaseServices _instance = FirebaseServices._internal();

  factory FirebaseServices() {
    return _instance;
  }

  FirebaseServices._internal();

  Future<UploadTask> uploadFile(
    String filePath, {
    String? fileName,
    String savePath = "File",
    SettableMetadata? metadata,
  }) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);

    String name =
        fileName ??
        "${DateTime.now().millisecondsSinceEpoch.toString()}.${filePath.split('.').last}";

    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef.child("$savePath/$name").putFile(file, metadata);
    return uploadTask;
  }

  Future<String?> downloadFile(String path) async {
    String? extractedPath = _extractFilePathFromDownloadUrl(path);

    if (extractedPath == null) {
      return null;
    }

    final storageRef = FirebaseStorage.instance.ref();
    final url = await storageRef.child(extractedPath).getDownloadURL();
    return url;
  }

  Future<bool> deleteFile(String path) async {
    String? extractedPath = _extractFilePathFromDownloadUrl(path);

    if (extractedPath != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref();
        await storageRef.child(extractedPath).delete();
        return true;
      } on FirebaseException catch (e) {
        print('Firebase Storage deletion error: ${e.code} - ${e.message}');
        if (e.code == 'object-not-found') {
          print('The file you tried to delete does not exist.');
        } else if (e.code == 'unauthorized') {
          print(
            'You do not have permission to delete this file. Check your Firebase Storage Security Rules.',
          );
        } else {
          print('An unknown Firebase error occurred during deletion.');
        }
      } catch (e) {
        print('An unknown error occurred during deletion: $e');
      }
    }
    return false;
  }

  String? _extractFilePathFromDownloadUrl(String downloadUrl) {
    try {
      final uri = Uri.parse(downloadUrl);
      final pathSegments = uri.pathSegments;
      final oIndex = pathSegments.indexOf('o');

      if (oIndex == -1 || oIndex == pathSegments.length - 1) {
        return null;
      }

      final encodedFilePath = pathSegments.sublist(oIndex + 1).join('/');
      return Uri.decodeFull(encodedFilePath);
    } catch (e) {
      print('Error parsing URL: $e');
      return null;
    }
  }
}
