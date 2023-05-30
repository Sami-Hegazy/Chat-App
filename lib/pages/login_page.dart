import 'package:chat_app/component/custom_button.dart';
import 'package:chat_app/component/custom_text_field.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/cubit/auth_cubit/auth_cubit.dart';
import 'package:chat_app/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../component/constant.dart';
import '../helper/snack_bar.dart';

class LoginPage extends StatelessWidget {
  static String id = 'loginPage';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? email, password;
    GlobalKey<FormState> formKey = GlobalKey();
    bool isLoading = false;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<ChatCubit>(context).getMessage();
          Navigator.pushReplacementNamed(context, ChatPage.id,
              arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showCustomSnackbar(
              context, state.errorMessage, Icons.error, kPrimaryColor);
          isLoading = false;
        }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
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
                            //isLoading = true;
                            BlocProvider.of<AuthCubit>(context)
                                .loginUser(email: email!, password: password!);
                          }
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
        ),
      ),
    );
  }
}
