import 'package:chat_firebase/model/service_response.dart';
import 'package:chat_firebase/utils/app_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService(this.firebaseAuth);
  final FirebaseAuth firebaseAuth;

  Future<ServiceResponse> signInWithEmailPassword(
      String email, String password) async {
    try {
      var result = await firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      AppUtil.debugPrint(result.user);
      return ServiceResponse.fromJson(
        {"status": true, "message": "success", "data": result.user},
      );
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
      return ServiceResponse.fromJson(
        {"status": false, "message": e.message.toString(), "data": ""},
      );
    }
  }

  Future<ServiceResponse> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      var res = await firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      AppUtil.debugPrint(res);
      res.user?.updateDisplayName(name);
      await firebaseAuth.currentUser?.reload();
      return ServiceResponse.fromJson(
        {"status": true, "message": "success", "data": res.user},
      );
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
      return ServiceResponse.fromJson(
        {"status": false, "message": e.message.toString(), "data": ""},
      );
    }
  }

  Future logOut() async {
    await firebaseAuth.signOut();
  }
}
