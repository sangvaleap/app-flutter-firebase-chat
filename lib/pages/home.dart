import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/services/message.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/chat_room_item.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _messageController;
  late MessageService service;
  bool _isLoading = false;

  @override
  void initState() {
    service = MessageService(FirebaseAuth.instance);
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 60),
        child: _buildChats(),
      ),
      floatingActionButton: _buildFooter(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Chat Room"),
      actions: [
        IconButton(
          onPressed: () {
            _showConfirmLogout();
          },
          icon: Icon(Icons.logout_rounded),
        ),
      ],
    );
  }

  _buildChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: service.loadStreamMessage(10),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var data = snapshot.data!.docs;
        return ListView.builder(
          itemBuilder: (context, index) {
            var msg =
                Message.fromJson(data[index].data() as Map<String, dynamic>);
            return ChatRoomItem(message: msg);
          },
          shrinkWrap: true,
          itemCount: data.length,
        );
      },
    );
  }

  _buildFooter() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 5),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              hintText: "Write your message",
            ),
          ),
          IconButton(
            onPressed: () {
              _sendMessage();
            },
            icon: Icon(
              Icons.send_rounded,
              color: _isLoading ? Colors.grey : AppColor.primary,
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  _sendMessage() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    var res = await service.sendMessage(_messageController.text);

    setState(() {
      _isLoading = false;
    });

    if (res.status) {
      _messageController.clear();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Chat",
            descriptions: res.message,
          );
        },
      );
    }
  }

  _showConfirmLogout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: Text("Would you like to log out?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop();
              AuthService auth = AuthService(FirebaseAuth.instance);
              await auth.logOut();
            },
            child: const Text(
              "Log out",
              style: TextStyle(color: AppColor.secondary),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
