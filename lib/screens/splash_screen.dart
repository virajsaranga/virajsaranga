import 'package:flutter/material.dart';
import 'package:todo_app/screens/login_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) => Navigator.push(
        context,
        MaterialPageRoute(builder: ((context) => const LoginScreen()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 5),
            Text(
              "MTodo",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 245, 180, 28)),
            )
          ],
        ),
      ),
    );
  }
}
