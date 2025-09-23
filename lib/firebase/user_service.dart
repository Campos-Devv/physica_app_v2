import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physica_app/utils/logger.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Collection references
  CollectionReference get _students => _firestore.collection('student_accounts');
  
  // Student status constants
  static const String STATUS_ACTIVE = 'active';
  static const String STATUS_INACTIVE = 'inactive';
  static const String STATUS_SUSPENDED = 'suspended';
  static const String STATUS_TRANSFERRED = 'transferred';
  static const String STATUS_GRADUATED = 'graduated';
  
  // Update student profile
  Future<void> updateStudentProfile(String userId, Map<String, dynamic> data) {
    return _students.doc(userId).update(data);
  }
  
  // Update student status
  Future<void> updateStudentStatus(String userId, String status) {
    return _students.doc(userId).update({
      'status': status,
      'statusUpdatedAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Helper methods for common status changes
  Future<void> activateStudent(String userId) {
    return updateStudentStatus(userId, STATUS_ACTIVE);
  }
  
  Future<void> deactivateStudent(String userId) {
    return updateStudentStatus(userId, STATUS_INACTIVE);
  }
  
  Future<void> suspendStudent(String userId) {
    return updateStudentStatus(userId, STATUS_SUSPENDED);
  }
  
  Future<void> markStudentTransferred(String userId) {
    return updateStudentStatus(userId, STATUS_TRANSFERRED);
  }
  
  Future<void> graduateStudent(String userId) {
    return updateStudentStatus(userId, STATUS_GRADUATED);
  }
  
  // Logout and clear persistence
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Simplified method to create a student - doesn't check for LRN uniqueness first
  Future<void> createStudentWithLrnCheck({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String lrn,
    required String strand,
    required String gender,
  }) async {
    try {
      // First, sanitize and validate the LRN format
      final sanitizedLrn = sanitizeLrn(lrn);
      
      if (!isLrnValidFormat(sanitizedLrn)) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'invalid-lrn-format',
          message: 'LRN must be exactly 12 digits'
        );
      }
      
      // Use the sanitized LRN for the rest of the operation
      lrn = sanitizedLrn;
      
      // EXPLICITLY CHECK IF LRN ALREADY EXISTS
      // IMPORTANT: This requires the auth user to be signed in already
      // and the rules to allow authenticated users to query the collection
      final QuerySnapshot lrnCheck = await _firestore
        .collection('student_accounts')
        .where('lrn', isEqualTo: lrn)
        .limit(1)
        .get();
    
      if (lrnCheck.docs.isNotEmpty) {
        throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'lrn-already-exists',
          message: 'An account with this LRN already exists'
        );
      }
    
      // Only create the document if LRN is unique
      final DocumentReference studentRef = _students.doc(userId);
      await studentRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'lrn': lrn,  // This is fine as a string
        'strand': strand,
        'gender': gender,
        'role': 'student',
        'status': STATUS_ACTIVE,
        'statusUpdatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Replace the print statement for successful profile creation
      AppLogger.info("Student profile created successfully for user: $userId");
    } on FirebaseException catch (e, stack) {
      if (e.code == 'lrn-already-exists') {
        AppLogger.warning("LRN already exists: ${e.message}");
      } else {
        AppLogger.error("Firebase error creating student profile", e, stack);
      }
      rethrow;
    } catch (e, stack) {
      AppLogger.error("Error creating student profile", e, stack);
      
      // Convert generic errors to FirebaseException for better error handling
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: 'profile-creation-failed',
        message: 'Failed to create student profile: ${e.toString()}'
      );
    }
  }
  
  // Helper method to validate and sanitize LRN
  String sanitizeLrn(String lrn) {
    // Remove any non-digit characters
    final sanitizedLrn = lrn.replaceAll(RegExp(r'[^\d]'), '');
    return sanitizedLrn;
  }
  
  // Check if LRN is valid format (12 digits)
  bool isLrnValidFormat(String lrn) {
    return RegExp(r'^\d{12}$').hasMatch(lrn);
  }
  
  // Check if an account is active
  Future<bool> isAccountActive(String userId) async {
    try {
      final doc = await _students.doc(userId).get();
      if (!doc.exists) {
        return false;
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      return data?['status'] == STATUS_ACTIVE;
    } catch (e, stack) {
      AppLogger.error("Error checking account status", e, stack);
      // Default to inactive if there's an error
      return false;
    }
  }

  // Get account status
  Future<String> getAccountStatus(String userId) async {
    try {
      final doc = await _students.doc(userId).get();
      if (!doc.exists) {
        return 'unknown';
      }
      
      final data = doc.data() as Map<String, dynamic>?;
      return data?['status'] ?? 'unknown';
    } catch (e) {
      AppLogger.error("Error getting account status", e);
      return 'unknown';
    }
  }
}