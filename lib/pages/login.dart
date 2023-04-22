import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidePwd = true;
  late AuthService service;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late RoundedLoadingButtonController _loginBtnController;

  @override
  void initState() {
    service = AuthService(FirebaseAuth.instance);
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginBtnController = RoundedLoadingButtonController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _buildRegisterButton(),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildLogo(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(
              height: 80,
            ),
            _buildEmail(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            _buildPassword(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 15,
            ),
            _buildForgotPassword(),
            const SizedBox(
              height: 25,
            ),
            _buildLogin(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 150,
      height: 150,
      child: CustomImage(
        "https://cdn-icons-png.flaticon.com/512/3820/3820331.png",
        isSVG: false,
        bgColor: AppColor.appBgColor,
        radius: 5,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: null,
        child: const Text(
          "Forgot Password?",
          style: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLogin() {
    return Row(
      children: [
        RoundedLoadingButton(
          width: MediaQuery.of(context).size.width,
          color: AppColor.primary,
          controller: _loginBtnController,
          onPressed: onLogin,
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future onLogin() async {
    FocusScope.of(context).unfocus();
    var res = await service.signInWithEmailPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (res.status) {
      _loginBtnController.success();
    } else {
      _loginBtnController.reset();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Login",
            descriptions: res.message,
          );
        },
      );
    }
  }

  Widget _buildPassword() {
    return CustomTextField(
      controller: _passwordController,
      leadingIcon: Icon(
        Icons.lock_outline,
        color: Colors.grey,
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _isHidePwd = !_isHidePwd;
          });
        },
        child: Icon(
          _isHidePwd
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey,
        ),
      ),
      obscureText: _isHidePwd,
      hintText: "Password",
    );
  }

  Widget _buildEmail() {
    return CustomTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      leadingIcon: Icon(
        Icons.email_outlined,
        color: Colors.grey,
      ),
      hintText: "Email",
    );
  }

  Widget _buildRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterPage(),
              ),
            );
          },
          child: Container(
            width: 90,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: const Text(
              "Register",
              style: TextStyle(color: AppColor.primary),
            ),
          ),
        )
      ],
    );
  }
}
