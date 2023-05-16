import 'package:chat_app/component/custom_button.dart';
import 'package:chat_app/component/custom_text_field.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component/constant.dart';
import '../helper/snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = 'loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 75),
                  Image.asset('assets/images/scholar.png'),
                  const Text(
                    'Scholar Chat',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: 'Pacifico',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOGIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    obscureText: false,
                    hintText: 'Email',
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isValidEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    obscureText: true,
                    hintText: 'Password',
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    textButton: 'Login',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await loginUser();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              ChatPage.id,
                              arguments: email,
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showCustomSnackbar(
                                context,
                                'No user found for that email.',
                                Icons.error,
                                kPrimaryColor);
                          } else if (e.code == 'wrong-password') {
                            showCustomSnackbar(
                                context,
                                'Wrong password provided for that user.',
                                Icons.error,
                                kPrimaryColor);
                          }
                        } catch (e) {
                          showCustomSnackbar(
                              context,
                              'There was an error! , Please try again',
                              Icons.error,
                              kPrimaryColor);
                        }
                        isLoading = false;
                        setState(() {});
                      } else {}
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account ? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, RegisterPage.id);
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: mintForst,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            decorationThickness: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
