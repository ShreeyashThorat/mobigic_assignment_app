import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobigic_assignment/data/logic/auth/login_bloc.dart';
import 'package:mobigic_assignment/views/auth/register_screen.dart';
import 'package:mobigic_assignment/views/dashboard/dashboard_screen.dart';

import '../../utils/constant_data.dart';
import '../../widgets/loading_widgets.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();
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
                SvgPicture.asset(
                    width: size.width * 0.8,
                    fit: BoxFit.contain,
                    ConstantImages.loginImages),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Form(
                    key: loginFormKey,
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
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {},
                          text: "Forgot Password",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: TextDecoration.underline)),
                    ),
                  ),
                ),
              ],
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const RegisterScreen()));
                          },
                        text: "Register",
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
              bloc: loginBloc,
              listener: (context, state) {
                if (state is LoginLoding) {
                  LoadingWidgets.showLoading(context, canPop: false);
                }
                if (state is LoginSuccessfully) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  DashboardScreen(userdata: state.userData,)),
                      (Route<dynamic> route) => false);
                  LoadingWidgets.showSnackBar(context, "LoggedIn Successfully");
                } else if (state is LoginError) {
                  Navigator.of(context).pop();
                  LoadingWidgets.showSnackBar(
                      context, state.exception.message!);
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
                        if (loginFormKey.currentState!.validate() &&
                            state is! LoginLoding) {
                          loginBloc.add(LoginButtonClicked(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim()));
                        }
                      },
                      elevation: 0,
                      buttonContent: const Text(
                        "SIGN IN",
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
      ),
    );
  }
}

Widget textfields(
    {required String title, required Widget child, required Size size}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 7),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 19, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        const SizedBox(height: 5),
        child
      ],
    ),
  );
}
