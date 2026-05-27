import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;
  FirebaseFirestore? _firestore;

  User? _user;
  User? get user => _user;

  AuthService() {
    _safeInit();
  }

  void _safeInit() {
    if (Firebase.apps.isNotEmpty) {
      try {
        _auth = FirebaseAuth.instance;
        _googleSignIn = GoogleSignIn();
        _firestore = FirebaseFirestore.instance;
        _user = _auth!.currentUser;

        _auth!.authStateChanges().listen((User? user) {
          _user = user;
          notifyListeners();
        });
      } catch (e) {
        debugPrint("Auth init error: \$e");
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    if (_auth == null) return null;
    try {
      await _googleSignIn?.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn?.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth!.signInWithCredential(credential);
      _user = userCredential.user;
      notifyListeners();
      return userCredential;
    } catch (e) {
      debugPrint("Google Sign-In Error: \$e");
      rethrow;
    }
  }

  // Restored updateProfile method
  Future<void> updateProfile(String name, String email) async {
    if (_user == null || _firestore == null) return;
    try {
      await _firestore!.collection('users').doc(_user!.uid).set({
        'name': name,
        'email': email,
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // Also update Firebase Auth display name if possible
      await _user!.updateDisplayName(name);
      await _user!.reload();
      _user = _auth!.currentUser;
      
      notifyListeners();
    } catch (e) {
      debugPrint("Profile update error: \$e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      await _auth?.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Sign out error: \$e");
    }
  }
}
