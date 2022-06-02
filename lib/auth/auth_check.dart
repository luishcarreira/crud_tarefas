// ignore_for_file: prefer_const_constructors

import 'package:crud_firebase/auth/auth_firebase_service.dart';
import 'package:crud_firebase/pages/home_page.dart';
import 'package:crud_firebase/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService auth = Provider.of<AuthFirebaseService>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.usuario == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            backgroundColor: Colors.grey,
            color: Colors.blue,
            strokeWidth: 10,
          ),
          SizedBox(height: 20),
          Text('Aguarde um momento...')
        ],
      ),
    ),
  );
}
