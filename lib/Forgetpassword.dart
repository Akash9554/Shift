import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shift/submit_button.dart';

import 'input_fields.dart';
import 'login.dart';
import 'login_controller.dart';



class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}
class _ForgotPasswordState extends State<ForgotPassword> {
  String emailError = 'Please enter email';
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugCheckHasOverlay(context);
    return Scaffold(

      backgroundColor: Color(0xFF73CDEF),
      appBar: AppBar(
        backgroundColor: Color(0xFF73CDEF), // Set the background color
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color:Color(0xFF142247)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        title: Text('Forgot your password',
          style: TextStyle(
            fontFamily: 'Poppins_normal',
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF142247),
          ),),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                'https://starinternational.com.au/roster/public/website_assets/logo.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 20),
              CustomTextField(
                  controller: emailController,
                  hintText: 'Username,Email or Member Number',
                  error: emailError,
                  onUseridValueChange: (value) {

                  }),
              SizedBox(height: 20),
              SubmitButton(
                handleButtonClick: () {
                  signin(context);
                },
                title: 'Reset Password',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signin(BuildContext context) {
      LoginController.forget(
        context,
        emailController.text
      );
  }
}
