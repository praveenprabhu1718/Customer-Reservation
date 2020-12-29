
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Admin {
  Admin({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<Admin> get onStateChanged;
  Future<Admin> getCurrentUser();
  Future<void> signOut();
  Future<Admin> signInWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  Admin _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return Admin(uid: user.uid);
  }

  @override
  Stream<Admin> get onStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<Admin> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<Admin> signInWithEmailAndPassword(String email, String password) async{
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
