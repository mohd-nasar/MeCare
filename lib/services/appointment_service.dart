import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String doctorId = "doctor_1";

  // Get booked slots for a specific date (Realtime)
  Stream<List<String>> getBookedSlots(DateTime date) {
    DateTime dayStart = DateTime(date.year, date.month, date.day);

    // Simplified query to potentially avoid composite index requirement for simple range
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .where('appointmentDate', isEqualTo: Timestamp.fromDate(dayStart))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['slot'] as String).toList();
    });
  }

  // Book an appointment
  Future<void> bookAppointment({
    required DateTime date,
    required String slot,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // Ensure we only store the DATE part to make the "isEqualTo" query work perfectly
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    // Atomic transaction for production-level safety
    return _firestore.runTransaction((transaction) async {
      final querySnapshot = await _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isEqualTo: Timestamp.fromDate(normalizedDate))
          .where('slot', isEqualTo: slot)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception("This slot was just booked by someone else.");
      }

      DocumentReference newApptRef = _firestore.collection('appointments').doc();
      
      transaction.set(newApptRef, {
        'patientId': user.uid,
        'patientName': user.displayName ?? "Patient",
        'patientEmail': user.email,
        'doctorId': doctorId,
        'appointmentDate': Timestamp.fromDate(normalizedDate),
        'slot': slot,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
