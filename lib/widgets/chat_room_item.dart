import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/utils/app_util.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomItem extends StatelessWidget {
  ChatRoomItem({Key? key, required this.message}) : super(key: key);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: _getGroupChat(),
    );
  }

  _getGroupChat() {
    return message.userId == _firebaseAuth.currentUser!.uid
        ? _buildMyMessage()
        : _buildOtherMessage();
  }

  Widget _buildMyMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: this.message.message,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(text: "   "),
                    TextSpan(
                      text: AppUtil.getTimeAgo(this.message.createdAt),
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOtherMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomImage(
          this.message.userId.toString(),
          width: 40,
          height: 40,
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 280),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightGreen.shade50,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.message.userName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 5,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: this.message.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    TextSpan(text: "   "),
                    TextSpan(
                      text: AppUtil.getTimeAgo(this.message.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
