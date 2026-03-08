import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseManager {
  // Singleton pattern
  static final FirebaseManager _instance = FirebaseManager._internal();

  factory FirebaseManager() {
    return _instance;
  }

  FirebaseManager._internal();

  Future<void> addData(String collection, String docId, Map<String, dynamic> data, [SetOptions? options]) async {
    final collectionRef = FirebaseFirestore.instance.collection(collection);
    await collectionRef.doc(docId).set(data, options).then((_) {
      print('Data added with ID: $docId');
    }).catchError((error) {
      print('Failed to add data: $error');
    });
  }

  Future<Map<String, dynamic>?> getData(String collection, String docId) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    try {
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        print('Document with ID $docId does not exist in collection $collection.');
        return null;
      }
    } catch (error) {
      print('Failed to get data: $error');
      return null;
    }
  }

  Future<void> updateData(String collection, String docId, Map<String, dynamic> newData) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    await docRef.update(newData).then((_) {
      print('Document with ID $docId updated successfully in collection $collection.');
    }).catchError((error) {
      print('Failed to update data: $error');
    });
  }

  Future<void> deleteData(String collection, String docId) async {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(docId);
    await docRef.delete().then((_) {
      print('Document with ID $docId deleted successfully from collection $collection.');
    }).catchError((error) {
      print('Failed to delete data: $error');
    });
  }
}