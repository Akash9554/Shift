import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback handleButtonClick;
  // final Function handleButtonClick;
  final String title;
  const SubmitButton(
      {Key? key, required this.handleButtonClick, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
      ]),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                      side: BorderSide.none)),
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(0xFF142247),
              )),
          onPressed: handleButtonClick,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins_normal',
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Colors.white,
            ),
          )),
    );
  }
}
