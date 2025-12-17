import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> saveProfile({
    required String name,
    required String phone,
    required bool isMale,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'phone': phone,
      'gender': isMale ? 'male' : 'female',
      'email': _auth.currentUser!.email,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}
