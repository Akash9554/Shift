
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shift/passwordfield.dart';
import 'package:shift/submit_button.dart';


import 'Forgetpassword.dart';
import 'Signup.dart';
import 'input_fields.dart';
import 'login_controller.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());
  final _globalKey = GlobalKey<FormState>();
  bool passwordvisible = true;
  final getstorage=GetStorage();


  String emailError = 'Please enter email';
  String passwordError = 'Please enter password';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Color(0xFF73CDEF),
        ),

        SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Image.asset("assets/images/shiftlogo.png",
                      height:250,
                      width: 250,),
                    const SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.all(25),
                      child: Center(
                          child: Form(
                            key: _globalKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomTextField(
                                    controller: emailController,
                                    hintText: 'Username,Email or Member Number',
                                    error: emailError,
                                    onUseridValueChange: (value) {

                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(height: 15),
                                PasswordField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                    passwordvisible: passwordvisible,
                                    error: passwordError,
                                    onUseridValueChange: (value) {
                                      //print(value);
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(

                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),

                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                SubmitButton(
                                  handleButtonClick: () {
                                    signin(context);
                                  },
                                  title: 'Log In',
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("By logging in, you accept",
                                      style: TextStyle(
                                        fontFamily: "Poppins_normal",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),),
                                    SizedBox(height: 6),
                                    Text("Life Time's Terms of Use",
                                      style: TextStyle(
                                        fontFamily: 'Poppins_normal',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xFF142247),
                                      ),),
                                    SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                                      },
                                      child: Text(
                                        "Forgot your username or password?",
                                        style: TextStyle(
                                          fontFamily: 'Poppins_normal',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(0xFF142247),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen()));
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "New member? ",
                                              style: TextStyle(
                                                fontFamily: 'Poppins_normal',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Create Account",
                                              style: TextStyle(
                                                fontFamily: 'Poppins_normal',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Color(0xFF142247),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),

                                  ],
                            ),
                          )),
                    )
                  ],
                ),

              ),
            ))
      ],
    );
  }

  void signin(BuildContext context) {
    final isValid = _globalKey.currentState!.validate();
    if (isValid) {
      LoginController.login(
        context,
        emailController.text,
        passwordController.text,
      );
    } else {
      return;
    }
  }


}
