
import 'package:chat_firebase/pages/home.dart';
import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'register.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isObscureText = true;
  AuthService service = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        body: getBody(),
        floatingActionButton: Visibility(visible: !keyboardIsOpen, child: getNavigationButton()),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      );

  }

  getBody(){
   return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(child: 
              Container(
                padding: EdgeInsets.all(10),
                width: 150,
                height: 150,
                child: CustomImage("https://cdn-icons-png.flaticon.com/512/3820/3820331.png",
                  isSVG: false,
                  bgColor: appBgColor,
                  radius: 5,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
            ),
            SizedBox(
              height: 80,
            ),
            CustomTextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              leadingIcon: Icon(Icons.email_outlined, color: Colors.grey,),
              hintText: "Email",
            ),
            Divider(
              color: Colors.grey,
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              controller: passwordController,
              leadingIcon: Icon(Icons.lock_outline, color: Colors.grey,),
              suffixIcon: GestureDetector(
                onTap: (){
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: Icon(isObscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
              ),
              obscureText: isObscureText,
              hintText: "Password",
            ),
            Divider(
              color: Colors.grey,
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){

                },
                child: Text("Forgot Password?", 
                  style: TextStyle(color: primary, fontWeight: FontWeight.w400, fontSize: 14)
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: 
                      RoundedLoadingButton(
                        width: MediaQuery.of(context).size.width,
                        color: primary,
                        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        controller: btnController,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          var res =  await service.signInWithEmailPassword(emailController.text, passwordController.text);
                          if(res["status"] == false){
                            btnController.reset();
                            showDialog(context: context,
                              builder: (BuildContext context){
                              return CustomDialogBox(
                                          title: "Login",
                                          descriptions: res["message"],
                                        );
                              }
                            );
                            
                          }else{
                            btnController.success();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => HomePage())
                              ,(route) => false);
                          }
                        },
                      ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }


  Widget getNavigationButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: (){
             Navigator.push(context, 
              MaterialPageRoute(builder: (context) => RegisterPage())
             );
            },
            child: Container(
              width: 90,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:  Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Text("Register", style: TextStyle(color: primary),)
            ),
          )
        ],
      )
    );
  }

}