import 'package:chatapp/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/helper/loading.dart';
import 'package:chatapp/helper/theme.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/chatrooms.dart';
import 'package:chatapp/views/forgot_password.dart';
import 'package:chatapp/views/otp.dart';
import 'package:chatapp/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String error = "";

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null) {
          // QuerySnapshot userInfoSnapshot =
          //     await DatabaseMethods().getUserInfo(emailEditingController.text);

          // HelperFunctions.saveUserLoggedInSharedPreference(true);
          // HelperFunctions.saveUserNameSharedPreference(
          //     userInfoSnapshot.documents[0].data["userName"]);
          // HelperFunctions.saveUserEmailSharedPreference(
          //     userInfoSnapshot.documents[0].data["userEmail"]);
          print("Login Successfully");
          setState(() {
            isLoading = false;
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            error = 'Please supply a valid email';
            print(error);
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarMain(context),
      body: isLoading
          ? Loading()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            width: size.width / 1.1,
                            child: Text(
                              "Welcome",
                              style: TextStyle(
                                fontSize: 34,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width / 1.1,
                            child: Text(
                              "Signin to Continue!",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height / 10,
                          ),
                          TextFormField(
                            controller: emailEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(EvaIcons.emailOutline),
                              hintText: 'email',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            controller: passwordEditingController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(EvaIcons.lockOutline),
                              hintText: 'password',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Enter Password 8+ characters";
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text("Forgot Password?",
                                  style: TextStyle(fontSize: 14))),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    RaisedButton(
                      color: kPrimaryColor,
                      child: Container(
                          height: 52.0,
                          width: size.width / 1.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: kPrimaryColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      onPressed: () {
                        signIn();
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 16,
                    ),

                    SizedBox(
                      height: 16,
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 16),
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(30),
                    //       color: Colors.white),
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Text(
                    //     "Sign In with Google",
                    //     style:
                    //         TextStyle(fontSize: 17, color: CustomTheme.textColor),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account? ",
                            style: TextStyle(fontSize: 14)),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                                color: Color(0xff007EF4),
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(error,
                        style: TextStyle(
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
