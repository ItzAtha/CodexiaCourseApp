import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/logger.dart';

class FirebaseManager {
  // Singleton pattern
  static final FirebaseManager _instance = FirebaseManager._internal();

  factory FirebaseManager() {
    return _instance;
  }

  FirebaseManager._internal();

  Future<void> addData(
    String collection,
    String docId,
    Map<String, dynamic> data, [
    SetOptions? options,
  ]) async {
    final collectionRef = FirebaseFirestore.instance.collection(collection);
    await collectionRef
        .doc(docId)
        .set(data, options)
        .then((_) {
          DebugLogger(
            message: 'Data added with ID $docId to collection $collection successfully.',
            level: LogLevel.info,
          ).log();
        })
        .catchError((error) {
          DebugLogger(
            message: 'Failed to add data: $error',
            stackTrace: StackTrace.current,
            level: LogLevel.error,
          ).log();
        });
  }

  Future<Map<String, dynamic>?> getData(String collection, String docId) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    try {
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        DebugLogger(
          message: 'Document with ID $docId does not exist in collection $collection.',
          level: LogLevel.info,
        ).log();
        return null;
      }
    } catch (error, stackTrace) {
      DebugLogger(
        message: 'Failed to get data: $error',
        stackTrace: stackTrace,
        level: LogLevel.error,
      ).log();
      return null;
    }
  }

  Future<void> updateData(String collection, String docId, Map<String, dynamic> newData) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    await docRef
        .update(newData)
        .then((_) {
          DebugLogger(
            message: 'Document with ID $docId updated successfully in collection $collection.',
            level: LogLevel.info,
          ).log();
        })
        .catchError((error) {
          DebugLogger(
            message: 'Failed to update data: $error',
            stackTrace: StackTrace.current,
            level: LogLevel.error,
          ).log();
        });
  }

  Future<void> deleteData(String collection, String docId) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    await docRef
        .delete()
        .then((_) {
          DebugLogger(
            message: 'Document with ID $docId deleted successfully from collection $collection.',
            level: LogLevel.info,
          ).log();
        })
        .catchError((error) {
          DebugLogger(
            message: 'Failed to delete data: $error',
            stackTrace: StackTrace.current,
            level: LogLevel.error,
          ).log();
        });
  }

  Future<bool> isDataExist(String collection, String docId) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    try {
      final docSnapshot = await docRef.get();

      DebugLogger(
        message:
            'Document with ID $docId from collection $collection exists: ${docSnapshot.exists}',
        level: LogLevel.info,
      ).log();
      return docSnapshot.exists;
    } catch (error) {
      DebugLogger(
        message: 'Failed to check data existence: $error',
        stackTrace: StackTrace.current,
        level: LogLevel.error,
      ).log();
      return false;
    }
  }
}
