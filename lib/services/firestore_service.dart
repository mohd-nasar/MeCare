import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Check if user profile exists and is complete
  Future<bool> isProfileComplete(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['profileCompleted'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Create or Update user profile
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String phone,
    required String age,
    required String gender,
    required String city,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'phone': phone,
      'age': age,
      'gender': gender,
      'city': city,
      'role': 'patient',
      'profileCompleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Stream of user data
  Stream<DocumentSnapshot> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}
