import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  GoogleSignIn? _googleSignIn;

  User? _user;
  User? get user => _user;

  AuthService() {
    _safeInit();
  }

  void _safeInit() {
    if (Firebase.apps.isNotEmpty) {
      try {
        debugPrint(
          "Initializing AuthService...",
        );

        _auth =
            FirebaseAuth.instance;

        _googleSignIn =
            GoogleSignIn();

        _user =
            _auth!.currentUser;

        _auth!
            .authStateChanges()
            .listen((User? user) {

          debugPrint(
            "Auth state changed: "
                "${user?.email}",
          );

          _user = user;
          notifyListeners();
        });

        debugPrint(
          "AuthService initialized SUCCESS",
        );

      } catch (e) {
        debugPrint(
          "Auth init error: $e",
        );
      }
    } else {
      debugPrint(
        "Firebase not initialized!",
      );
    }
  }

  User? getCurrentUser() {
    return _auth?.currentUser;
  }

  bool get isLoggedIn =>
      _auth?.currentUser != null;

  Future<UserCredential?>
  signInWithGoogle() async {

    if (_auth == null) {
      debugPrint(
        "Firebase Auth NULL",
      );
      return null;
    }

    try {
      debugPrint(
        "Google Sign-In started",
      );

      // Remove previous account selection
      await _googleSignIn
          ?.signOut();

      final GoogleSignInAccount?
      googleUser =
      await _googleSignIn
          ?.signIn();

      if (googleUser == null) {
        debugPrint(
          "User cancelled login",
        );
        return null;
      }

      debugPrint(
        "Selected account: "
            "${googleUser.email}",
      );

      final GoogleSignInAuthentication
      googleAuth =
      await googleUser
          .authentication;

      debugPrint(
        "Google authentication success",
      );

      final AuthCredential
      credential =
      GoogleAuthProvider
          .credential(
        accessToken:
        googleAuth.accessToken,
        idToken:
        googleAuth.idToken,
      );

      debugPrint(
        "Firebase sign-in started",
      );

      final UserCredential
      userCredential =
      await _auth!
          .signInWithCredential(
        credential,
      );

      debugPrint(
        "Firebase sign-in SUCCESS",
      );

      _user =
          userCredential.user;

      notifyListeners();

      return userCredential;

    } catch (e) {
      debugPrint(
        "Google Sign-In Error: $e",
      );

      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint(
        "Signing out...",
      );

      await _googleSignIn
          ?.signOut();

      await _auth?.signOut();

      _user = null;

      notifyListeners();

      debugPrint(
        "Sign out SUCCESS",
      );

    } catch (e) {
      debugPrint(
        "Sign out error: $e",
      );
    }
  }
}