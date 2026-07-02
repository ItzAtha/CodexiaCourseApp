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

  Future<bool?> deleteFile(String filePath, String fileName) async {
    String fullPath = '$filePath/$fileName';
    bool isFileExists = await _isFileExists(fullPath);

    if (!isFileExists) return null;

    try {
      final storageRef = FirebaseStorage.instance.ref();
      await storageRef.child(fullPath).delete();
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
    return false;
  }

  Future<bool> _isFileExists(String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.getMetadata();
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return false;
      }
      rethrow;
    }
  }
}
