
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool validatedField;
  final bool readOnly;
  final bool obscureText;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onChanged;
  const CustomTextField({ Key? key, this.onTap, this.onChanged, this.keyboardType, this.controller, this.hintText, this.labelText, this.readOnly = false, this.validatedField = true, this.errorText = 'Cannot be empty', this.leadingIcon, this.suffixIcon, this.obscureText = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
      TextField(
        onTap: onTap,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: Theme.of(context).accentColor,
        readOnly: readOnly,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: leadingIcon !=null ? leadingIcon : null,
          suffixIcon: suffixIcon !=null ? suffixIcon : null,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
              color: Colors.grey, 
              fontSize: 15
          ),
          labelText: labelText,
          errorText: validatedField ? null : errorText,
        ),
      );
  }
}
