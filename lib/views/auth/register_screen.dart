import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobigic_assignment/data/logic/auth/register_bloc.dart';
import 'package:mobigic_assignment/views/dashboard/dashboard_screen.dart';

import '../../widgets/loading_widgets.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_textfield.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterUserBloc registerUserBloc = RegisterUserBloc();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                  key: registerFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      textfields(
                          title: "Email address",
                          size: size,
                          child: MyTextField(
                            controller: emailController,
                            hintText: "Email",
                            maxLines: 1,
                            radius: 8,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Email address  is required";
                              } else if (!validateEmail(val)) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                          )),
                      textfields(
                          title: "First name",
                          size: size,
                          child: MyTextField(
                            controller: firstnameController,
                            hintText: "First name",
                            maxLines: 1,
                            radius: 8,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                          )),
                      textfields(
                          title: "Last name",
                          size: size,
                          child: MyTextField(
                            controller: lastnameController,
                            hintText: "Last name",
                            maxLines: 1,
                            radius: 8,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          )),
                      textfields(
                          title: "Date of Birth",
                          size: size,
                          child: MyTextField(
                            controller: dobController,
                            hintText: "2000-01-01",
                            maxLines: 1,
                            radius: 8,
                            readOnly: true,
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (selectedDate != null) {
                                dobController.text = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                              }
                            },
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Please enter your DOB";
                              }
                              return null;
                            },
                          )),
                      textfields(
                          title: "Password",
                          size: size,
                          child: MyTextField(
                            controller: passwordController,
                            hintText: "Password",
                            maxLines: 1,
                            radius: 8,
                            isObscure: true,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return "Password can not be empty";
                              } else if (!validatePassword(val)) {
                                return "Your password must contain at least one uppercase letter, one symbol, and one digit.";
                              } else if (val.length < 8) {
                                return "Password must be greater that 8 digit";
                              }
                              return null;
                            },
                          )),
                    ],
                  ))
            ],
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      )),
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Navigator.of(context).pop();
                        },
                      text: "Login",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ))
                ]),
              ),
            ),
          ),
          BlocConsumer(
            bloc: registerUserBloc,
            listener: (context, state) {
              if (state is RegisterLoding) {
                LoadingWidgets.showLoading(context, canPop: false);
              }
              if (state is RegisterSuccessfully) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardScreen(
                              userdata: state.userData,
                            )),
                    (Route<dynamic> route) => false);
                LoadingWidgets.showSnackBar(context, "LoggedIn Successfully");
              } else if (state is RegisterError) {
                Navigator.of(context).pop();
                LoadingWidgets.showSnackBar(context, state.exception.message!);
              }
            },
            builder: (context, state) {
              return Container(
                width: size.width,
                height: 48,
                margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05, vertical: 20),
                child: MyElevatedButton(
                    onPress: () {
                      if (registerFormKey.currentState!.validate() &&
                          state is! RegisterLoding) {
                        registerUserBloc.add(RegisterButtonClicked(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            dob: dobController.text.trim(),
                            firstname: firstnameController.text.trim(),
                            lastname: lastnameController.text.trim()));
                      }
                    },
                    elevation: 0,
                    buttonContent: const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
              );
            },
          )
        ],
      ),
    ));
  }
}
