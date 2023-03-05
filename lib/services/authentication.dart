import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/login_screen.dart';

class Authentication {
  //Register the user
  static Future<void> signup(
      String email, String password, BuildContext context) async {
    try {
      //Save the email and password in Authentication
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((_) => {
                //If successfull registered, redirect to the Home Screen
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const HomeScreen()))),
                //Display a snackbar
                AnimatedSnackBar.material(
                  'Successfully Registered',
                  type: AnimatedSnackBarType.success,
                ).show(context)
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //If email is already registered, a snackbar will display
        AnimatedSnackBar.material(
          'The account already exists for that email',
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  //Login the user using email and password
  static Future<void> userLogin(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (_) => {
              //If successfull registered, redirect to the Home Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: ((context) => const HomeScreen()),
                ),
              ),
              //Display a snackbar
              AnimatedSnackBar.material(
                'Successfully Logged in',
                type: AnimatedSnackBarType.success,
              ).show(context)
            },
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AnimatedSnackBar.material(
          'No user found for that email.',
          type: AnimatedSnackBarType.error,
        ).show(context);
      } else if (e.code == 'wrong-password') {
        AnimatedSnackBar.material(
          'Wrong password provided for that user.',
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    }
  }

  //Sign out the user
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((_) => {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => const LoginScreen()),
            ),
          ),
          AnimatedSnackBar.material(
            'Successfully Logged out',
            type: AnimatedSnackBarType.warning,
          ).show(context)
        });
  }
}
