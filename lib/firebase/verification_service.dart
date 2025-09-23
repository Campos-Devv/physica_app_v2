import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:physica_app/utils/logger.dart';

class VerificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _verificationCodes => 
      _firestore.collection('verification_codes');
  
  String _generateVerificationCode() {
    final random = Random();
    final code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  Future<String> sendVerificationCode(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No account exists for this email.',
        );
      }

      final verificationCode = _generateVerificationCode();

      await _verificationCodes.doc(email).set({
        'code' : verificationCode,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(minutes: 10)),
        ),
        'isUsed': false,
      });

      return verificationCode;
    } catch (e, stack) {
      AppLogger.error("Error sending verification code", e, stack);
      rethrow;
    }
  }

  Future<bool>verifyCode(String email, String enteredCode) async {
    try {
      final docSnapshot = await _verificationCodes.doc(email).get();

      if (!docSnapshot.exists) {
        AppLogger.warning("No Verification code found for email: $email");
        return false;
      }
      
      final data = docSnapshot.data() as Map<String, dynamic>?;
      final storedCode = data?['code'] as String?;
      final isUsed = data?['isUsed'] as bool? ?? false;
      final expiresAt = data?['expiresAt'] as Timestamp?;

      final now = Timestamp.now();
      final isExpired = expiresAt == null || now.compareTo(expiresAt) > 0;

      if (isUsed) {
        AppLogger.warning("Verification code has already been used for email: $email");
      }

      if (isExpired) {
        AppLogger.warning("Verification code has expired for email: $email");
      }
      
      if (storedCode == null || isExpired) {
        AppLogger.warning("Verification code is invalid or expired for email: $email");
        return false;
      }

      final isValid = storedCode == enteredCode;

      if (isValid) {

        await _verificationCodes.doc(email).update({
          'isUsed': true,
          'verifiedAt': FieldValue.serverTimestamp(),
        });
        AppLogger.info("Verification successful for email: $email");
      } else {
        AppLogger.warning("Invalid verification code for email: $email");
      }

      return isValid;
    } catch (e, stack) {
      AppLogger.error("Error verifying code", e, stack);
      return false;
    }
  }

  Future<bool>canResetPassword(String email) async {
    try {
      final docSnapshot = await _verificationCodes.doc(email).get();

      if (!docSnapshot.exists) {
        return false;
      }

      final data = docSnapshot.data() as Map<String, dynamic>?;
      return data?['isUsed'] == true && data?['verifiedAt'] != null;
    } catch (e) {
      AppLogger.error("Error checking reset eligibility", e);
      return false;
    }
  }

  Future<void> resetPassword(String email, String newPassword) async {
    try {
      final canReset = await canResetPassword(email);

      if (!canReset) {
        throw FirebaseAuthException(
          code: 'verification-required',
          message: 'Verification is required before resetting password.',
        );
      }
      
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No account exists for this email.',
        );
      }

      await _auth.sendPasswordResetEmail(email: email);


      AppLogger.info("Password reset initiated for email: $email");
    } catch (e, stack) {
      AppLogger.error("Error resetting password", e, stack);
      rethrow;
    }
  }
}