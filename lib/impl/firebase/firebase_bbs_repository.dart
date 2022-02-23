import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bbs_entry.dart';
import '../../repositories/bbs_repository.dart';

class FirebaseBbsRepository extends BbsRepository {
  final FirebaseFirestore firestore;
  final CollectionReference<Map<String, dynamic>> collectionRef;
  final int listLimit;

  FirebaseBbsRepository({
    required this.firestore,
    this.listLimit = 100,
  }) : collectionRef = firestore.collection('bbs');

  @override
  Stream<List<BbsEntry>> entries() {
    return collectionRef
        .orderBy('updatedAt', descending: true)
        .where('deleted', isEqualTo: false)
        .limit(listLimit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final updatedAt = data['updatedAt'] as Timestamp;

        return BbsEntry(
          id: doc.id,
          name: data['name'],
          title: data['title'],
          body: data['body'],
          textColor: data['textColor'],
          deleteKey: data['deleteKey'],
          updatedAt: updatedAt.toDate(),
        );
      }).toList();
    });
  }

  @override
  Future<void> save(BbsEntry entry) {
    return collectionRef.add({
      'name': entry.name,
      'title': entry.title,
      'body': entry.body,
      'textColor': entry.textColor,
      'deleteKey': entry.deleteKey,
      'deleted': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> delete(BbsEntry entry) {
    return collectionRef.doc(entry.id).update({
      'deleteKey': entry.deleteKey,
      'deleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
