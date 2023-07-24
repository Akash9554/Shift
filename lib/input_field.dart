import 'package:flutter/material.dart';

class CustomTextFields extends StatelessWidget {
  TextEditingController controller;
  final String hintText;
  final String error;
  final String text;
  final Function onUseridValueChange;
  CustomTextFields({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.error,
    required this.text,
    required this.onUseridValueChange,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: TextFormField(
        initialValue: text,
        style:const TextStyle(
            decoration: TextDecoration.none,
            color: Color.fromARGB(255, 235, 235, 235),
            fontFamily: "Poppins_normal",
            fontSize: 14,

            fontWeight: FontWeight.w500),
        controller: controller,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return error;
          } else {
            return null;
          }
        },
        onChanged: (value) {
          onUseridValueChange(value);
        },
        decoration: InputDecoration(
            alignLabelWithHint: true,
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.white54,
            )),
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
            fillColor: Colors.white54,
            hintText: hintText,
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 215, 214, 214)),
            contentPadding: const EdgeInsets.only(bottom: 15),
            focusColor: Colors.white54),
        autofocus: true,
        keyboardType: TextInputType.multiline,
      ),
    );
  }
}
