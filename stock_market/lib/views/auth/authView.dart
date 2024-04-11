import 'package:flutter/material.dart';

import 'loginView.dart';
import 'registerView.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool login = true;

  @override
  void initState() {
    super.initState();
  }

  void switchView() {
    setState(() {
      login = !login;
    });

  }

  @override
  Widget build(BuildContext context) {
    if(login) {
      return LoginView(tap: switchView);
    }else {
      return RegisterView(tap: switchView);
    }

  }

}