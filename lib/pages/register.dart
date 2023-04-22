import 'package:chat_firebase/services/auth.dart';
import 'package:chat_firebase/theme/color.dart';
import 'package:chat_firebase/utils/app_util.dart';
import 'package:chat_firebase/widgets/custom_dialog.dart';
import 'package:chat_firebase/widgets/custom_image.dart';
import 'package:chat_firebase/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _hidedPwd = true;
  bool _hidenConfirmPwd = true;
  late AuthService service;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confrimPasswordController;
  late RoundedLoadingButtonController _loginBtnController;

  @override
  void initState() {
    service = AuthService(FirebaseAuth.instance);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confrimPasswordController = TextEditingController();
    _loginBtnController = RoundedLoadingButtonController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confrimPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _buildLoginButton(),
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
              "Register",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            const SizedBox(
              height: 40,
            ),
            _buildName(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 10,
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
              height: 10,
            ),
            _buildConfirmPassword(),
            const Divider(
              color: Colors.grey,
              height: 10,
            ),
            const SizedBox(
              height: 30,
            ),
            _buildRegister(),
          ],
        ),
      ),
    );
  }

  Widget _buildName() {
    return CustomTextField(
      controller: _nameController,
      leadingIcon: Icon(
        Icons.person_outline,
        color: Colors.grey,
      ),
      hintText: "Name",
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
            _hidedPwd = !_hidedPwd;
          });
        },
        child: Icon(
          _hidedPwd ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.grey,
        ),
      ),
      obscureText: _hidedPwd,
      hintText: "Password",
    );
  }

  Widget _buildConfirmPassword() {
    return CustomTextField(
      controller: _confrimPasswordController,
      leadingIcon: Icon(
        Icons.lock_outline,
        color: Colors.grey,
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            _hidenConfirmPwd = !_hidenConfirmPwd;
          });
        },
        child: Icon(
          _hidenConfirmPwd
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey,
        ),
      ),
      obscureText: _hidenConfirmPwd,
      hintText: "Confirm Password",
    );
  }

  Widget _buildRegister() {
    return Row(
      children: [
        RoundedLoadingButton(
          width: MediaQuery.of(context).size.width,
          color: AppColor.primary,
          child: const Text(
            "Register",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          controller: _loginBtnController,
          onPressed: () async {
            FocusScope.of(context).unfocus();
            _onRegister();
          },
        ),
      ],
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

  Widget _buildLoginButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 80,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
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
              child: Text(
                "Login",
                style: TextStyle(color: AppColor.primary),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _onRegister() async {
    if (!validatePassword(
        _passwordController.text, _confrimPasswordController.text)) {
      return;
    }

    var res = await service.registerWithEmailPassword(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    if (res.status) {
      _loginBtnController.success();
      AppUtil.debugPrint("Success");
    } else {
      _loginBtnController.reset();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Register",
            descriptions: res.message,
          );
        },
      );
    }
  }

  bool validatePassword(String pwd, String confPwd) {
    if (pwd != confPwd) {
      _loginBtnController.reset();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            descriptions: "Password and Confirm Password are not matched.",
          );
        },
      );
      return false;
    }
    return true;
  }
}
