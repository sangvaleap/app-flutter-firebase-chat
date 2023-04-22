import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/model/service_response.dart';
import 'package:chat_firebase/utils/app_util.dart';
import 'package:chat_firebase/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  MessageService(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;
  final _database = FirebaseFirestore.instance;

  Future<ServiceResponse> sendMessage(String message) async {
    final newMessage = Message(
      userId: firebaseAuth.currentUser!.uid,
      userName: firebaseAuth.currentUser!.displayName ?? "N/A",
      roomId: ROOM_ID,
      message: message.trim(),
      messageType: MessageType.text,
      createdAt: DateTime.now(),
    );

    try {
      var refMessage = _database.collection(ROOM_COLLECTION);
      var res = await refMessage.add(newMessage.toJson());
      AppUtil.debugPrint(res);
      return ServiceResponse.fromJson(
        {"status": true, "message": "success"},
      );
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.message);
      return ServiceResponse.fromJson(
        {"status": false, "message": e.message.toString()},
      );
    }
  }

  Stream<QuerySnapshot> loadStreamMessage(int limit) {
    return _database
        .collection(ROOM_COLLECTION)
        .orderBy('createdAt')
        .snapshots();
  }
}
