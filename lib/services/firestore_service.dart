
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of documents from a collection
  Stream<List<T>> getCollection<T>({
    required String path,
    required T Function(DocumentSnapshot doc) builder,
  }) {
    final reference = _firestore.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) =>
        snapshot.docs.map((doc) => builder(doc)).toList());
  }

  // Get a stream of a single document
  Stream<T> getDocument<T>({
    required String path,
    required T Function(DocumentSnapshot doc) builder,
  }) {
    final reference = _firestore.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot));
  }

  // Add a document to a collection
  Future<DocumentReference> addDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    final reference = _firestore.collection(path);
    return reference.add(data);
  }

  // Update a document
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    final reference = _firestore.doc(path);
    return reference.update(data);
  }

  // Delete a document
  Future<void> deleteDocument({required String path}) {
    final reference = _firestore.doc(path);
    return reference.delete();
  }
  
  // Set a document with a specific ID
  Future<void> setDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    final reference = _firestore.doc(path);
    return reference.set(data);
  }
}
