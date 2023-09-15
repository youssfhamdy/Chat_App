import 'package:chat_app/Pages/chat_page.dart';
import 'package:chat_app/Pages/login_page.dart';
import 'package:chat_app/helper/show_snak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/Pages/register.dart';
import 'package:chat_app/Widgets/custom_text_field.dart';
import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/Widgets/CustomButton.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  static String id = 'LoginPage';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 75,
                ),
                Image.asset(
                  'assets/images/scholar.png',
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontFamily: 'Pacifico'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomFormTextField(
                    hintText: 'Email',
                    onChanged: (data) {
                      email = data;
                    }),
                const SizedBox(
                  height: 20,
                ),
                CustomFormTextField(
                  obscureText: true,
                    hintText: 'Password',
                    onChanged: (data) {
                      password = data;
                    }),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  text: 'Login',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, ChatPage.id , arguments: email);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnakbar(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showSnakbar(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (e) {
                        showSnakbar(context, 'there was an Erorr');
                      }
                      isLoading = false;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'don\'t have an account ?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(
                        '   Register',
                        style: TextStyle(
                          color: Colors.red,
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
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}

