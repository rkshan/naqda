import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email & password sign up
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  // Email & password sign in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Start phone verification (sends SMS)
  Future<void> verifyPhone(String phoneNumber, Function(String verificationId) codeSent, Function(FirebaseAuthException) verificationFailed) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in on Android devices which can auto-retrieve the SMS
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) async {
        verificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) async {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Verify SMS code and sign in
  Future<UserCredential> signInWithSmsCode(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCred = await _auth.signInWithCredential(credential);
    return userCred;
  }
}
