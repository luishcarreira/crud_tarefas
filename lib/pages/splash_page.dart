import 'package:crud_firebase/auth/auth_check.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
    ).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthCheck()),
      ),
    );
    return const Scaffold(
      body: Center(
        child: FlutterLogo(),
      ),
    );
  }
}
