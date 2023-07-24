import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  final String hintText;
  final String error;

  final Function onUseridValueChange;
  CustomTextField({
    Key? key,

    required this.controller,
    required this.hintText,
    required this.error,
    required this.onUseridValueChange,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child:
      TextFormField(

        style:const TextStyle(
            decoration: TextDecoration.none,
            color: Color(0xFF142247),
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
              color: Color(0xFF142247),
            )),
            focusedBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color:  Color(0xFF142247))),
            fillColor: Color(0xFF142247),
            hintText: hintText,
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
