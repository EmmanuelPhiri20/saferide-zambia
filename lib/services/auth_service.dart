
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

// FIREBASE INSTANCES
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

// =========================
// REGISTER USER
// =========================

  Future<String> registerUser({

    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,

  }) async {
    try {
// CREATE AUTH ACCOUNT
      UserCredential userCredential =

      await _auth
          .createUserWithEmailAndPassword(

        email: email,
        password: password,
      );

// SAVE USER TO FIRESTORE
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({

        'uid':
        userCredential.user!.uid,

        'fullName':
        fullName,

        'email':
        email,

        'phone':
        phone,

        'role':
        role,

        'profileCompleted':
        false,

        'createdAt':
        FieldValue.serverTimestamp(),
      });

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ??
          "Registration Failed";
    } catch (e) {
      return e.toString();
    }
  }

// =========================
// LOGIN USER
// =========================

  Future<String> loginUser({

    required String email,
    required String password,

  }) async {
    try {
      await _auth
          .signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message ??
          "Login Failed";
    } catch (e) {
      return e.toString();
    }
  }

// =========================
// LOGOUT
// =========================

  Future<void> logout() async {
    await _auth.signOut();
  }
}
