import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ChatService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  static const String doctorId =
      "doctor_1";

  // -----------------------------
  // SEND MESSAGE
  // -----------------------------
  Future<void> sendMessage(
      String message, {
        String? fileUrl,
        String? fileName,
        String? fileType,
      }) async {
    final user =
        _auth.currentUser;

    if (user == null) return;

    if (message.trim().isEmpty &&
        fileUrl == null) {
      return;
    }

    final chatId = user.uid;

    final chatDoc =
    _firestore
        .collection('chats')
        .doc(chatId);

    // Update chat header
    await chatDoc.set({
      'patientId':
      user.uid,

      'patientName':
      user.displayName ??
          "Patient",

      'patientEmail':
      user.email,

      'doctorId':
      doctorId,

      'lastMessage':
      fileUrl != null
          ? fileType ==
          'pdf'
          ? '📄 PDF Document'
          : '📷 Photo'
          : message,

      'updatedAt':
      FieldValue
          .serverTimestamp(),
    },
        SetOptions(
            merge: true));

    // Add actual message
    await chatDoc
        .collection(
        'messages')
        .add({
      'messageType':
      fileUrl == null
          ? 'text'
          : fileType,

      'text': message,

      'fileUrl':
      fileUrl,

      'fileName':
      fileName,

      'fileType':
      fileType,

      'senderId':
      user.uid,

      'senderType':
      'patient',

      'isRead':
      false,

      'timestamp':
      FieldValue
          .serverTimestamp(),
    });
  }

  // -----------------------------
  // FILE UPLOAD
  // -----------------------------
  Future<String?> uploadFile(
      File file) async {
    final user =
        _auth.currentUser;

    if (user == null) {
      print(
          "No logged in user");
      return null;
    }

    try {
      final fileName =
      basename(
          file.path);

      // FIXED PATH
      final destination =
          'chat_files/${user.uid}/$fileName';

      print(
          "Uploading file to: $destination");

      final ref =
      _storage.ref(
          destination);

      UploadTask task =
      ref.putFile(
        file,
        SettableMetadata(
          contentType:
          _getMimeType(
              fileName),
        ),
      );

      TaskSnapshot
      snapshot =
      await task;

      final url =
      await snapshot
          .ref
          .getDownloadURL();

      print(
          "Upload Success!");

      print(url);

      return url;
    } on FirebaseException catch (e) {
      print(
          "Firebase Storage Error: ${e.code}");
      print(e.message);
      return null;
    } catch (e) {
      print(
          "Upload Error: $e");
      return null;
    }
  }

  // -----------------------------
  // GET MESSAGES
  // -----------------------------
  Stream<QuerySnapshot>
  getMessages() {
    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
          "User not logged in");
    }

    return _firestore
        .collection(
        'chats')
        .doc(user.uid)
        .collection(
        'messages')
        .orderBy(
      'timestamp',
      descending: true,
    )
        .snapshots();
  }

  // -----------------------------
  // MIME TYPE
  // -----------------------------
  String _getMimeType(
      String fileName) {
    final ext =
    extension(fileName)
        .toLowerCase();

    switch (ext) {
      case '.pdf':
        return 'application/pdf';

      case '.png':
        return 'image/png';

      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';

      default:
        return 'application/octet-stream';
    }
  }
}