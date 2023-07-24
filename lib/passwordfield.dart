import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  TextEditingController controller;
  final String hintText;
  final String error;
  bool passwordvisible;
  final Function onUseridValueChange;

  PasswordField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.error,
    required this.onUseridValueChange,
    required this.passwordvisible,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: TextFormField(
        style: const TextStyle(
            decoration: TextDecoration.none,
            color:  Color(0xFF142247),
            fontFamily: "Poppins_normal",
            fontSize: 14,
            fontWeight: FontWeight.w500),
        controller: widget.controller,
        obscureText: widget.passwordvisible,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
              return widget.error;
          } else {
            return null;
          }
        },
        onChanged: (value) {
          widget.onUseridValueChange(value);
        },
        decoration: InputDecoration(
            alignLabelWithHint: true,
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color:  Color(0xFF142247),
            )),
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color:  Color(0xFF142247))),
            fillColor:  Color(0xFF142247),
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: Icon(
                widget.passwordvisible
                    ? Icons.visibility_off
                    :  Icons.visibility,
                color:  Color(0xFF142247),
              ),
              onPressed: () {
                setState(
                  () {
                    widget.passwordvisible = !widget.passwordvisible;
                  },
                );
              },
            ),
            hintStyle:
                const TextStyle(color:  Color(0xFF142247)),
            contentPadding: const EdgeInsets.only(bottom: 5),
            focusColor: Color(0xFF142247)),
        autofocus: true,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
