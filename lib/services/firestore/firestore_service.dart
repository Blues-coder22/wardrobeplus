import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> saveClothingItem(
      Map<String, dynamic> data,
      ) async {
    await _firestore
        .collection('wardrobe_items')
        .add(data);
  }

  Stream<QuerySnapshot> getClothingItems(
      String userId) {
    return _firestore
        .collection('wardrobe_items')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> deleteItem(String id) async {
    await _firestore
        .collection('wardrobe_items')
        .doc(id)
        .delete();
  }
}