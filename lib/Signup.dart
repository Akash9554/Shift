import 'package:flutter/material.dart';
import 'package:shift/login.dart';
import 'package:shift/passwordfield.dart';
import 'package:shift/signup_controller.dart';
import 'package:shift/submit_button.dart';

import 'Notify.dart';
import 'input_fields.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController mobilenumbercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  String nameError = 'Please enter name';
  String lastError = 'Please enter last name';
  String mobileNumber = 'Please enter mobile number';
  String emailError = 'Please enter email address';
  String paswordError = 'Please enter password';

  bool passwordvisible = true;

  // Create a list to hold the selected qualification IDs
  List<int> selectedQualificationIds = [];
  String stateid="";
  String fs_shift="";

  @override
  Widget build(BuildContext context) {
    debugCheckHasOverlay(context);
    return Scaffold(
        backgroundColor: Color(0xFF73CDEF),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/images/shiftlogo.png",
                  height: 50,
                  width: 50,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                    controller: firstnamecontroller,
                    hintText: 'Username',
                    error: nameError,
                    onUseridValueChange: (value) {}),
                CustomTextField(
                    controller: lastnamecontroller,
                    hintText: 'Lastname',
                    error: lastError,
                    onUseridValueChange: (value) {}),
                CustomTextField(
                    controller: mobilenumbercontroller,
                    hintText: 'Mobile number',
                    error: mobileNumber,
                    onUseridValueChange: (value) {}),
                CustomTextField(
                    controller: emailcontroller,
                    hintText: 'Email address',
                    error: emailError,
                    onUseridValueChange: (value) {}),
                const SizedBox(height: 5),
                PasswordField(
                    controller: passwordcontroller,
                    hintText: 'Password',
                    passwordvisible: passwordvisible,
                    error: paswordError,
                    onUseridValueChange: (value) {
                      //print(value);
                    }),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(1),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(1);
                      } else {
                        selectedQualificationIds.remove(1);
                      }
                    });
                  },
                  title: Text('SUBWATCH',
                    style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(2),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(2);
                      } else {
                        selectedQualificationIds.remove(2);
                      }
                    });
                  },
                  title: Text('SHIPWATCH', style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(3),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(3);
                      } else {
                        selectedQualificationIds.remove(3);
                      }
                    });
                  },
                  title: Text('ERT', style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(4),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(4);
                      } else {
                        selectedQualificationIds.remove(4);
                      }
                    });
                  },
                  title: Text('TRAINER', style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(5),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(5);
                      } else {
                        selectedQualificationIds.remove(5);
                      }
                    });
                  },
                  title: Text('PSC', style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                CheckboxListTile(
                  value: selectedQualificationIds.contains(6),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedQualificationIds.add(6);
                      } else {
                        selectedQualificationIds.remove(6);
                      }
                    });
                  },
                  title: Text('TRAINEE', style: TextStyle(
                    fontFamily: 'Poppins_normal',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF142247),
                  ),),
                ),
                // Repeat CheckboxListTile for other qualifications ...

                DropdownButtonFormField<String>(
                  value: '0',
                  items: [
                    DropdownMenuItem(value: '0', child: Text('Select State', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'SA', child: Text('SA', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'WA', child: Text('WA', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                  ],
                  onChanged: (value) {
                    stateid=value!;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: '0',
                  items: [
                    DropdownMenuItem(value: '0', child: Text('Select FS Shift', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'A', child: Text('A', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'B', child: Text('B', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'C', child: Text('C', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'D', child: Text('D', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                    DropdownMenuItem(value: 'None', child: Text('None', style: TextStyle(
                      fontFamily: 'Poppins_normal',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF142247),
                    ),)),
                  ],
                  onChanged: (value) {
                    fs_shift=value!;
                  },
                ),
                SubmitButton(
                  handleButtonClick: () {
                    // Convert the list of selected qualification IDs to a comma-separated string
                    String selectedQualificationsString = selectedQualificationIds.join(',');
                    String stateids = "";
                    String fsids = "";
                    if(firstnamecontroller.text.isEmpty){
                      Notify.snackbar("", "Please enter first name");
                    }else if(lastnamecontroller.text.isEmpty){
                      Notify.snackbar("", "Please enter last name");
                    }else if(mobilenumbercontroller.text.isEmpty){
                      Notify.snackbar("", "Please enter mobile number");
                    }else if(emailcontroller.text.isEmpty){
                      Notify.snackbar("", "Please enter email address");
                    }else if(passwordcontroller.text.isEmpty){
                      Notify.snackbar("", "Please enter password");
                    }else if(selectedQualificationsString==""){
                      Notify.snackbar("", "Please Select Qualification");
                    }else if(stateid==""){
                      Notify.snackbar("", "Please Select State");
                    }else if(fs_shift==""){
                      Notify.snackbar("", "Please Select FS Shift");
                    } else {
                      if (fs_shift == "A") {
                        fsids = "1";
                      } else if (fs_shift == "B") {
                        fsids = "2";
                      } else if (fs_shift == "C") {
                        fsids = "3";
                      } else if (fs_shift == "D") {
                        fsids = "4";
                      } else if (fs_shift == "None") {
                        fsids = "5";
                      }


                      if (stateid == "SA") {
                        stateids = "1";
                        signin(
                            context,
                            firstnamecontroller.text,
                            lastnamecontroller.text,
                            mobilenumbercontroller.text,
                            emailcontroller.text,
                            passwordcontroller.text,
                            stateids,
                            fsids,
                            selectedQualificationsString);
                      } else if (stateid == "WA") {
                        stateids = "2";
                        signin(
                            context,
                            firstnamecontroller.text,
                            lastnamecontroller.text,
                            mobilenumbercontroller.text,
                            emailcontroller.text,
                            passwordcontroller.text,
                            stateids,
                            fsids,
                            selectedQualificationsString);
                      }
                    }

                  },
                  title: 'Sign Up',
                ),
                Text('Already have an account?',style: TextStyle(
                  fontFamily: 'Poppins_normal',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF142247),
                ),),

                SubmitButton(
                  handleButtonClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  title: 'Log In',
                ),
              ],
            ),
          ),
        ),
      );
  }
  void signin(BuildContext context,String firstname,String lastname,String mobileno,String email, String password,String stateid,String fsshift,String qualification) {
      SignUpController.login(
        context,
        firstname,
          lastname,
          mobileno,
          email,
          password,
          stateid,
          fsshift,
          qualification
      );
  }

}
