import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../adapter/firebaseAdapter.dart';
import '../../helper/helper.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/textFieldWidget.dart';

class LoginView extends StatefulWidget {
  final void Function()? tap;

  const LoginView({super.key, this.tap});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final FirebaseAdapter  firebaseA = FirebaseAdapter();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  String errorCheck() {
    String ret = "";

    if(emailC.text.isEmpty) {
      if(ret.isNotEmpty) { ret += "\n"; }
      ret += "No email entered";
    }
    if(passwordC.text.isEmpty) {
      if(ret.isNotEmpty) { ret += "\n"; }
      ret += "No password entered";
    }

    return ret;
  }

  void login() async {
    Helper.circleDialog(context);

    String err = errorCheck();

    if(err.isNotEmpty) {
      Navigator.pop(context);

      Helper.messageToUser(err,context);

      return;
    }

    try {
      firebaseA.login(emailC.text,passwordC.text);
      Navigator.pushNamed(context,"/stocks");
    } on FirebaseAuthException catch(e) {
      Navigator.pop(context);
      Helper.messageToUser(e.code,context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //App name
              const Text("Stock market",style: TextStyle(fontSize: 20) ),
              const SizedBox(height: 50,),
              //Email
              TextFieldWidget(hint: "Email", controller: emailC),
              const SizedBox(height: 10,),
              //Password
              TextFieldWidget(hint: "Password", controller: passwordC,obscure: true),
              const SizedBox(height: 25,),
              //Login
              ExpandedButtonWidget(text: "Login", tap: login),
              const SizedBox(height: 25,),
              //Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.tap,
                    child: const Text(" Register here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );

  }
}