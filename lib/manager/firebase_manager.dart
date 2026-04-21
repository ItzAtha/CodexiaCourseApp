import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/utils/logger.dart';

class FirebaseManager {
  // Singleton pattern
  static final FirebaseManager _instance = FirebaseManager._internal();

  factory FirebaseManager() {
    return _instance;
  }

  FirebaseManager._internal();

  Future<String?> addData(
    String collection, {
    String? docId,
    Map<String, dynamic>? data,
    List<SubCollectionQuery>? subCollectionQuery,
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
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      if (collectionQuery.data == null) {
        throw Exception('Data must be provided when sub-collection query is provided.');
      }

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        final docRef = collectionRef.doc(collectionQuery.docId);

        await docRef.set(collectionQuery.data!, options);
        DebugLogger(
          message:
              'Data added with ID ${docRef.id} '
              'to sub-collection ${collectionQuery.collection} '
              'parent collection $collection successfully.',
          level: LogLevel.info,
        ).log();

        return docRef.id;
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to add data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    } else {
      if (data == null) {
        throw Exception('Data must be provided when sub-collection query is not provided.');
      }

      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        final docRef = collectionRef.doc(docId);

        await docRef.set(data, options);
        DebugLogger(
          message: 'Data added with ID $docId to collection $collection successfully.',
          level: LogLevel.info,
        ).log();

        return docRef.id;
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to add data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getData(
    String collection,
    String docId, {
    List<SubCollectionQuery>? subCollectionQuery,
    GetOptions? options,
  }) async {
    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        final docSnapshot = await collectionRef.doc(collectionQuery.docId).get(options);

        bool isDocExist = await isDocumentExist(
          collection,
          docId,
          subCollectionQuery: subCollectionQuery,
        );
        if (isDocExist) {
          return docSnapshot.data();
        } else {
          DebugLogger(
            message:
                'Document with ID ${collectionQuery.docId} does '
                'not exist in sub-collection ${collectionQuery.collection} '
                'parent collection $collection.',
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
      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        final docSnapshot = await collectionRef.doc(docId).get(options);

        bool isDocExist = await isDocumentExist(collection, docId);
        if (isDocExist) {
          return docSnapshot.data();
        } else {
          DebugLogger(
            message: 'Document with ID $docId does not exist in collection $collection.',
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
    }
    return null;
  }

  Future<(QueryDocumentSnapshot<Object?>, List<Map<String, dynamic>>)?> getDataWithCondition(
    String collection, {
    List<FilterCondition> conditions = const [],
    String? docId,
    List<SubCollectionQuery>? subCollectionQuery,
    DocumentSnapshot? lastDocument,
    OrderBy? orderBy,
    int? limit,
  }) async {
    assert(docId != null && subCollectionQuery != null, 'docId and subCollectionQuery must be provided.');

    if (subCollectionQuery != null) {
      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
        bool isLast = subCollectionQuery.last == query;
        String newPath = "";

        if (isLast) {
          newPath = query.collection;
        } else {
          newPath = "${query.collection}/${query.docId}";
        }

        return newPath;
      }).join('/')}";

      try {
        var collectionRef = FirebaseFirestore.instance.collection(
            path) as Query;

        for (final condition in conditions) {
          if (condition.isEqualTo != null) {
            collectionRef = collectionRef.where(
                condition.field, isEqualTo: condition.isEqualTo);
          }

          if (condition.isGreaterThan != null) {
            collectionRef = collectionRef.where(
              condition.field,
              isGreaterThan: condition.isGreaterThan,
            );
          }

          if (condition.isLessThan != null) {
            collectionRef = collectionRef.where(
                condition.field, isLessThan: condition.isLessThan);
          }

          if (condition.arraysContains != null) {
            collectionRef = collectionRef.where(
              condition.field,
              arrayContains: condition.arraysContains,
            );
          }
        }

        if (orderBy != null) {
          collectionRef = collectionRef.orderBy(
              orderBy.field, descending: orderBy.descending);
        }

        if (lastDocument != null) {
          collectionRef = collectionRef.startAfterDocument(lastDocument);
          print("Last document loaded: ${lastDocument.id}");
        }

        if (limit != null) {
          collectionRef = collectionRef.limit(limit);
        }

        final querySnapshot = await collectionRef.get();
        return (querySnapshot.docs.last, querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to get data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    } else {
      try {
        var collectionRef = FirebaseFirestore.instance.collection(
            collection) as Query;

        for (final condition in conditions) {
          if (condition.isEqualTo != null) {
            collectionRef = collectionRef.where(
                condition.field, isEqualTo: condition.isEqualTo);
          }

          if (condition.isGreaterThan != null) {
            collectionRef = collectionRef.where(
              condition.field,
              isGreaterThan: condition.isGreaterThan,
            );
          }

          if (condition.isLessThan != null) {
            collectionRef = collectionRef.where(
                condition.field, isLessThan: condition.isLessThan);
          }

          if (condition.arraysContains != null) {
            collectionRef = collectionRef.where(
              condition.field,
              arrayContains: condition.arraysContains,
            );
          }
        }

        if (orderBy != null) {
          collectionRef = collectionRef.orderBy(
              orderBy.field, descending: orderBy.descending);
        }

        if (lastDocument != null) {
          collectionRef = collectionRef.startAfterDocument(lastDocument);
        }

        if (limit != null) {
          collectionRef = collectionRef.limit(limit);
        }

        final querySnapshot = await collectionRef.get();
        return (querySnapshot.docs.last, querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
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
    List<SubCollectionQuery>? subCollectionQuery,
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
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      if (collectionQuery.data == null) {
        throw Exception('Data must be provided when sub-collection query is provided.');
      }

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        await collectionRef
            .doc(collectionQuery.docId)
            .update(collectionQuery.data!)
            .then((_) {
              DebugLogger(
                message:
                    'Document with ID ${collectionQuery.docId} updated '
                    'successfully in sub-collection ${collectionQuery.collection} '
                    'parent collection $collection.',
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
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to update data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    } else {
      if (newData == null) {
        throw Exception('Data must be provided when sub-collection query is not provided.');
      }

      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        await collectionRef
            .doc(docId)
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
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to update data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    }
  }

  Future<void> deleteData(
    String collection,
    String docId, {
    List<SubCollectionQuery>? subCollectionQuery,
  }) async {
    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        await collectionRef
            .doc(collectionQuery.docId)
            .delete()
            .then((_) {
              DebugLogger(
                message:
                    'Document with ID ${collectionQuery.docId} deleted '
                    'successfully in sub-collection ${collectionQuery.collection} '
                    'parent collection $collection.',
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
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to delete data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    } else {
      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        await collectionRef
            .doc(docId)
            .delete()
            .then((_) {
              DebugLogger(
                message:
                    'Document with ID $docId deleted successfully from collection $collection.',
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
      } catch (error, stackTrace) {
        DebugLogger(
          message: 'Failed to delete data: $error',
          stackTrace: stackTrace,
          level: LogLevel.error,
        ).log();
      }
    }
  }

  Future<bool> isCollectionEmpty(
    String collection, {
    String? docId,
    List<SubCollectionQuery>? subCollectionQuery,
  }) async {
    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        final querySnapshot = await collectionRef.limit(1).get();

        DebugLogger(
          message:
              'Documents in sub-collection ${collectionQuery.collection} of parent '
              'collection $collection exists? ${querySnapshot.docs.isNotEmpty}',
          level: LogLevel.info,
        ).log();
        return querySnapshot.docs.isNotEmpty;
      } catch (error) {
        DebugLogger(
          message: 'Failed to check document existence in collection $collection: $error',
          stackTrace: StackTrace.current,
          level: LogLevel.error,
        ).log();
      }
    } else {
      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        final querySnapshot = await collectionRef.limit(1).get();

        DebugLogger(
          message: 'Documents in collection $collection exists? ${querySnapshot.docs.isNotEmpty}',
          level: LogLevel.info,
        ).log();
        return querySnapshot.docs.isNotEmpty;
      } catch (error) {
        DebugLogger(
          message: 'Failed to check document existence in collection $collection: $error',
          stackTrace: StackTrace.current,
          level: LogLevel.error,
        ).log();
      }
    }

    return false;
  }

  Future<bool> isDocumentExist(
    String collection,
    String docId, {
    List<SubCollectionQuery>? subCollectionQuery,
  }) async {
    if (subCollectionQuery != null) {
      SubCollectionQuery collectionQuery = subCollectionQuery.last;

      String path =
          "$collection/$docId/${subCollectionQuery.map((query) {
            bool isLast = subCollectionQuery.last == query;
            String newPath = "";

            if (isLast) {
              newPath = query.collection;
            } else {
              newPath = "${query.collection}/${query.docId}";
            }

            return newPath;
          }).join('/')}";

      try {
        final collectionRef = FirebaseFirestore.instance.collection(path);
        final querySnapshot = await collectionRef.doc(collectionQuery.docId).get();

        DebugLogger(
          message:
              'Document with ID ${collectionQuery.docId} in sub-collection '
              '${collectionQuery.collection} of parent collection '
              '$collection exists? ${querySnapshot.exists}',
          level: LogLevel.info,
        ).log();
        return querySnapshot.exists;
      } catch (error) {
        DebugLogger(
          message: 'Failed to check document existence: $error',
          stackTrace: StackTrace.current,
          level: LogLevel.error,
        ).log();
      }
    } else {
      try {
        final collectionRef = FirebaseFirestore.instance.collection(collection);
        final querySnapshot = await collectionRef.doc(docId).get();

        DebugLogger(
          message:
              'Document with ID $docId from collection $collection exists? ${querySnapshot.exists}',
          level: LogLevel.info,
        ).log();
        return querySnapshot.exists;
      } catch (error) {
        DebugLogger(
          message: 'Failed to check document existence: $error',
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
  final String? docId;
  final Map<String, dynamic>? data;

  SubCollectionQuery({required this.collection, this.docId, this.data});
}

class FilterCondition {
  final String field;
  final dynamic isEqualTo;
  final dynamic isGreaterThan;
  final dynamic isLessThan;
  final dynamic arraysContains;

  FilterCondition({
    required this.field,
    this.isEqualTo,
    this.isGreaterThan,
    this.isLessThan,
    this.arraysContains,
  });
}

class OrderBy {
  final String field;
  final bool descending;

  OrderBy({required this.field, this.descending = false});
}
