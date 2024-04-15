import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../adapter/firebaseAdapter.dart';
import '../../helper/helper.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/textFieldWidget.dart';

class RegisterView extends StatefulWidget{
  final void Function()? tap;

  const RegisterView({super.key,this.tap});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final FirebaseAdapter  firebaseA = FirebaseAdapter();
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  String errorCheck() {
    String ret = "";

    if(usernameC.text.isEmpty) {
      ret += "Username is missing";
    }
    if(emailC.text.isEmpty) {
      if(ret.isNotEmpty) { ret += "\n"; }
      ret += "No email entered";
    }

    if(passwordC.text.isEmpty) {
      if(ret.isNotEmpty) { ret += "\n"; }
      ret += "No password entered";
    } else if(passwordC.text != confirmPasswordC.text) {
      if(ret.isNotEmpty) { ret += "\n"; }
      ret += "Passwords does not match";
    }

    return ret;
  }

  void register() async {
    Helper.circleDialog(context);

    String err = errorCheck();

    if(err.isNotEmpty) {
      Navigator.pop(context);

      Helper.messageToUser(err,context);

      return;
    }

    try{
      firebaseA.register(usernameC.text,emailC.text,passwordC.text);
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
              //Username
              TextFieldWidget(hint: "Username", controller: usernameC),
              const SizedBox(height: 10,),
              //Email
              TextFieldWidget(hint: "Email", controller: emailC),
              const SizedBox(height: 10,),
              //Password
              TextFieldWidget(hint: "Password", controller: passwordC,obscure: true),
              const SizedBox(height: 25,),
              //Password
              TextFieldWidget(hint: "Confirm password", controller: confirmPasswordC,obscure: true),
              const SizedBox(height: 25,),
              ButtonWidget(text: "Register", tap: register),
              const SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account?"),
                  GestureDetector(
                    onTap: widget.tap,
                    child: const Text(" Login here",
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
