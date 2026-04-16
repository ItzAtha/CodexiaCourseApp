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
    String docId, {
    Map<String, dynamic>? data,
    SubCollectionQuery? subCollectionQuery,
    SetOptions? options,
  }) async {
    assert(
      data != null || subCollectionQuery != null,
      'Data or sub-collection query must be provided.',
    );
    assert(
      data == null || subCollectionQuery == null,
      'Only one of data or sub-collection query can be provided.',
    );

    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery;

      if (collectionQuery.data == null) {
        throw Exception('Data must be provided when sub-collection query is provided.');
      }

      final collectionRef = FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .collection(collectionQuery.collection);

      await collectionRef
          .doc(collectionQuery.docId)
          .set(collectionQuery.data!, options)
          .then((_) {
            DebugLogger(
              message:
                  'Data added with ID $docId to sub-collection ${collectionQuery.collection} successfully.',
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
    } else {
      if (data == null) {
        throw Exception('Data must be provided when sub-collection query is not provided.');
      }

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
  }

  Future<Map<String, dynamic>?> getData(
    String collection,
    String docId, {
    SubCollectionQuery? subCollectionQuery,
    GetOptions? options,
  }) async {
    if (subCollectionQuery != null) {
      final collectionRef = FirebaseFirestore.instance.collection(collection);

      try {
        final querySnapshot = await collectionRef
            .doc(docId)
            .collection(subCollectionQuery.collection)
            .get(options);

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.data();
        } else {
          DebugLogger(
            message:
                'No document found with ID $docId in sub-collection ${subCollectionQuery.collection}.',
            level: LogLevel.info,
          ).log();
        }
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to get data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    } else {
      final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);

      try {
        final docSnapshot = await docRef.get(options);

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
      }
    }
    return null;
  }

  Future<void> updateData(
    String collection,
    String docId, {
    Map<String, dynamic>? newData,
    SubCollectionQuery? subCollectionQuery,
  }) async {
    assert(
      newData != null || subCollectionQuery != null,
      'Data or sub-collection query must be provided.',
    );
    assert(
      newData == null || subCollectionQuery == null,
      'Only one of data or sub-collection query can be provided.',
    );

    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery;

      if (collectionQuery.data == null) {
        throw Exception('Data must be provided when sub-collection query is provided.');
      }

      final collectionRef = FirebaseFirestore.instance.collection(collection);
      await collectionRef
          .doc(docId)
          .collection(collectionQuery.collection)
          .doc(collectionQuery.docId)
          .update(collectionQuery.data!)
          .then((_) {
            DebugLogger(
              message:
                  'Document with ID $docId updated successfully in sub-collection ${collectionQuery.collection}.',
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
    } else {
      if (newData == null) {
        throw Exception('Data must be provided when sub-collection query is not provided.');
      }

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
  }

  Future<void> deleteData(
    String collection,
    String docId, {
    SubCollectionQuery? subCollectionQuery,
  }) async {
    if (subCollectionQuery != null) {
      final collectionRef = FirebaseFirestore.instance.collection(collection);
      await collectionRef
          .doc(docId)
          .collection(subCollectionQuery.collection)
          .doc(subCollectionQuery.docId)
          .delete()
          .then((_) {
            DebugLogger(
              message:
                  'Document with ID $docId deleted successfully from sub-collection ${subCollectionQuery.collection}.',
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
    } else {
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
  }

  Future<bool> isDataExist(
    String collection,
    String docId, {
    SubCollectionQuery? subCollectionQuery,
  }) async {
    if (subCollectionQuery != null) {
      final collectionRef = FirebaseFirestore.instance.collection(collection);
      try {
        final querySnapshot = await collectionRef
            .doc(docId)
            .collection(subCollectionQuery.collection)
            .doc(subCollectionQuery.docId)
            .get();

        DebugLogger(
          message:
              'Document with ID $docId from sub-collection ${subCollectionQuery.collection} exists: ${querySnapshot.exists}',
          level: LogLevel.info,
        ).log();
        return querySnapshot.exists;
      } catch (error) {
        DebugLogger(
          message: 'Failed to check data existence: $error',
          stackTrace: StackTrace.current,
          level: LogLevel.error,
        ).log();
      }
    } else {
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
      }
    }

    return false;
  }
}

class SubCollectionQuery {
  final String collection;
  final String docId;
  final Map<String, dynamic>? data;

  SubCollectionQuery({required this.collection, required this.docId, this.data});
}
