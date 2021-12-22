import 'package:chat_firebase/model/message.dart';
import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/services/message.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/chat_room_item.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageController = TextEditingController();
  bool isLoading = false;
  MessageService service = MessageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        title: 
          Column(
            children: [
              Text("Chat Room"),
            ],
          ),
        actions: [
          Container(
            child: IconButton(
              onPressed: (){
                showConfirmLogout();
              }, 
              icon: Icon(Icons.logout_rounded)
            )
          ),
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: getChats()
        ),
      ),
      floatingActionButton: getBottom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  getChats(){
    return StreamBuilder<QuerySnapshot>(
      stream: service.getMessageStream(10),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Container();
        }
        var data = snapshot.data!.docs;
        print(data.length);
       return ListView.builder(itemBuilder: (context, index) {
         var msg = Message.fromJson(data[index].data() as Map<String, dynamic>);
         return ChatRoomItem(message: msg);
       }, shrinkWrap: true, itemCount: data.length);
    });
  }

  getBottom(){
    return 
      Container(
        padding: EdgeInsets.only(left: 15, right: 5),
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              child: CustomTextField(
                controller: messageController,
                hintText: "Write your message",
              )
            ),
          ),
          IconButton(
            onPressed: () {
              sendMessage();
            },
            icon: Icon(Icons.send_rounded, color: isLoading ? Colors.grey : primary, size: 35,)
          )
        ],),
      );
  }

  sendMessage() async{
    if(isLoading) return;
    setState(() {
      isLoading = true;
    });

    var res = await service.sendMessage(messageController.text);

    setState(() {
      isLoading = false;
    });
    if(res["status"] == true){
      messageController.clear();
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context){
        return CustomDialogBox(title: "Chat", descriptions: res["message"],);
        }
      );
    }
  }

  showConfirmLogout(){
    showCupertinoModalPopup(
      context: context, 
      builder: (context) =>
        CupertinoActionSheet(
          message: Text("Would you like to log out?"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: (){
                AuthService auth = AuthService();
                auth.logOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), 
                (route) => false);
              },
              child: Text("Log Out", style: TextStyle(color: secondary),),
            )
          ],
          cancelButton: 
            CupertinoActionSheetAction(child:
              Text("Cancel"),
              onPressed: (){
               Navigator.of(context).pop();
              },
            )
        )
    );
  }
}