import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  Future signInWithEmailPassword(String email, String password) async {
    try {
      var result =  await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      print(result.user);
      return {"status" : true, "message" : "success", "data" : result.user} ;
      
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status" : false, "message" : e.message.toString(), "data" : ""};
    }
  }

  Future registerWithEmailPassword(String name, String email, String password) async {
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
       print(res);
      res.user?.updateDisplayName(name);
      return {"status" : true, "message" : "success", "data" : res.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return {"status" : false, "message" : e.message.toString(), "data" : ""};
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

}