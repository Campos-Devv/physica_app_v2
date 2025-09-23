import 'package:firebase_auth/firebase_auth.dart';
import 'package:physica_app/firebase/user_service.dart';
import 'package:physica_app/firebase/verification_service.dart';
import 'package:physica_app/utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final VerificationService _verificationService = VerificationService();
  
  // Register a new student
  Future<UserCredential> registerStudent({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String lrn,
    required String strand,
    required String gender,
  }) async {
    try {
      // Validate LRN format first
      if (lrn.length != 12 || !RegExp(r'^\d{12}$').hasMatch(lrn)) {
        throw FirebaseAuthException(
          code: 'invalid-lrn-format',
          message: 'LRN must be exactly 12 digits',
        );
      }
      
      // Optimistically create the auth account
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      try {
        // Create the student profile
        await _userService.createStudentWithLrnCheck(
          userId: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          lrn: lrn,
          strand: strand,
          gender: gender,
        );
        
        return userCredential;
      } catch (e, stack) {
        // If profile creation fails, delete the auth account
        try {
          await userCredential.user?.delete();
        } catch (deleteError) {
          AppLogger.error("Error deleting user after profile creation failed", deleteError);
        }

        if (e is FirebaseException && e.code == 'lrn-already-exists') {
          throw FirebaseAuthException(
            code: 'lrn-already-exists',
            message: 'An account with this LRN already exists',
          );
        } else if (e.toString().contains('permission-denied')) {
          throw FirebaseAuthException(
            code: 'permission-denied',
            message: 'Unable to create account due to permission issues. Please check your Firestore rules.',
          );
        }
        
        // Replace these print statements with AppLogger
        AppLogger.error("Error in createStudentWithLrnCheck", e, stack);
        
        // Convert any error to a FirebaseAuthException for consistent error handling
        throw FirebaseAuthException(
          code: 'profile-creation-failed',
          message: 'Failed to create student profile: ${e.toString()}',
        );
      }
    } on FirebaseAuthException catch (e, stack) {
      AppLogger.error("Firebase Auth Error", e, stack);
      rethrow;
    } catch (e, stack) {
      AppLogger.error("Error registering student", e, stack);
      
      // Convert to FirebaseAuthException for consistent error handling in UI
      throw FirebaseAuthException(
        code: 'registration-failed',
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }
  
  // Sign in user with account status check
  Future<UserCredential> signIn(String email, String password) async {
    try {
      AppLogger.info("Attempting login with email: $email");
      
      // First authenticate with Firebase Auth
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      AppLogger.info("Firebase Auth successful for user: ${credential.user?.uid}");
      
      // Now check if the account is active in Firestore
      final userId = credential.user!.uid;
      final isActive = await _userService.isAccountActive(userId);
      
      if (!isActive) {
        // Get the specific account status
        final status = await _userService.getAccountStatus(userId);
        
        // Sign out the user since they shouldn't be logged in
        await _auth.signOut();
        
        // Throw appropriate exception based on status
        throw FirebaseAuthException(
          code: 'account-$status',
          message: 'Your account is currently $status. Please contact your administrator.',
        );
      }
      
      AppLogger.info("Login successful and account is active for user: ${credential.user?.uid}");
      return credential;
      
    } on FirebaseAuthException catch (e) {
      // Log the error with appropriate detail level
      AppLogger.error("Firebase Auth Error: ${e.code} for email: $email", e);
      
      // Rethrow with original error code - let the UI handle the messaging
      rethrow;
    } catch (e, stack) {
      AppLogger.error("Unexpected error during sign in", e, stack);
      
      // Convert to FirebaseAuthException for consistent error handling
      throw FirebaseAuthException(
        code: 'sign-in-failed',
        message: 'Sign in failed: ${e.toString()}',
      );
    }
  }
  
  // Sign out user
  Future<void> signOut() async {
    try {
      await _userService.logout();
    } catch (e, stack) {
      AppLogger.error("Error signing out", e, stack);
      // We don't rethrow here because sign out failures are less critical
    }
  }
  
  // Get current user
  User? get currentUser => _auth.currentUser;

  // Add this new method
  Future<bool> checkEmailExists(String email) async {
    try {
      // Use Firebase Auth's fetchSignInMethodsForEmail
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw e;
      }
      // Other errors - safely assume email doesn't exist
      return false;
    }
  }

  Future<String> sendPasswordResetCode(String email) async {
    try {
      final emailExists = await checkEmailExists(email);

      if (!emailExists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No account exists with this email.',
        );
      }

      final code = await _verificationService.sendVerificationCode(email);
      return code;
    } catch (e, stack) {
      AppLogger.error("Error sending password reset code", e, stack);
      rethrow;
    }
  }

  Future<bool> verifyPasswordResetCode(String email, String code) async {
    try {
      return await _verificationService.verifyCode(email, code);
    } catch (e, stack) {
      AppLogger.error("Error verifying password reset code", e, stack);
      rethrow;
    }
  }

  // Update the completePasswordReset method:

  Future<void> completePasswordReset(String email, String newPassword) async {
    try {
      // For now, use Firebase Auth's built-in reset
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.info("Password reset link sent for email: $email");
    } catch (e, stack) {
      AppLogger.error("Error sending password reset email", e, stack);
      rethrow;
    }
  }

  /*Future<void> completePasswordReset(String email, String newPassword) async {
    try {
      final canReset = await _verificationService.canResetPassword(email);

      if (!canReset) {
        throw FirebaseAuthException(
          code: 'verification-required',
          message: 'Verification is required before resetting password.',
        );
      }

      await _auth.sendPasswordResetEmail(email: email);

      AppLogger.info("Password reset completed for email: $email");
    } catch (e, stack) {
      AppLogger.error("Error completing password reset", e, stack);
      rethrow;
    }
  } */
} 



extension FirebaseAuthErrorExtension on FirebaseAuthException {
  // A simpler and more direct approach without switch statements
  String get userFriendlyMessage {
    // Map of error codes to user-friendly messages
    final messages = {
      'user-not-found': 'No account exists with this email. Please sign up first.',
      'wrong-password': 'The password you entered is incorrect. Please try again.',
      'invalid-email': 'Please enter a valid email address.',
      'user-disabled': 'This account has been disabled. Please contact support.',
      'too-many-requests': 'Too many failed login attempts. Please try again later.',
      'network-request-failed': 'Network error. Please check your internet connection.',
      'sign-in-failed': message ?? 'Sign in failed. Please try again.',
      'email-already-in-use': 'This email is already registered. Please sign in instead.',
      'weak-password': 'Password is too weak. Please use a stronger password.',
      'operation-not-allowed': 'This operation is not allowed. Please contact support.',
      'invalid-credential': 'Your email or password is incorrect.',
      'account-inactive': 'Your account is currently inactive. Please contact your administrator.',
      'account-suspended': 'Your account has been suspended. Please contact your administrator.',
      'account-transferred': 'Your account has been marked as transferred. Please contact your administrator.',
      'account-graduated': 'Your account has been marked as graduated. Please contact your administrator if this is an error.',
      'account-unknown': 'There is an issue with your account status. Please contact your administrator.',
    };
    
    // Return the message for this code, or a default message if code not found
    return messages[code] ?? 'Authentication failed: ${code}';
  }
  
  // Get appropriate field-specific error message
  String? get emailFieldError {
    if (code == 'user-not-found') return 'No account found';
    if (code == 'invalid-email') return 'Invalid email format';
    if (code == 'user-disabled') return 'Account disabled';
    if (code == 'email-already-in-use') return 'Email already in use';
    // We don't set invalid-credential here as we handle it specially in _handleAuthError
    
    // Return null for all other error types
    return null;
  }
  
  // Get appropriate password field error
  String? get passwordFieldError {
    if (code == 'wrong-password') return 'Incorrect password';
    if (code == 'weak-password') return 'Password too weak';
    // We don't set invalid-credential here as we handle it specially in _handleAuthError
    
    // Return null for all other error types
    return null;
  }
  
  // Helper to determine if this is a generic credential error
  bool get isCredentialError => 
    code == 'invalid-credential' || 
    code == 'user-not-found' || 
    code == 'wrong-password';
    
  // Determine if this is an account status error
  bool get isAccountStatusError => code.startsWith('account-');
  
  // Get the status from the error code
  String get accountStatus => isAccountStatusError ? code.substring(8) : '';
}