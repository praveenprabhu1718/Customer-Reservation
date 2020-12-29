
import 'package:customer_reservation_app/app/pages/home_page.dart';
import 'package:customer_reservation_app/app/pages/login_page.dart';
import 'package:customer_reservation_app/app/services/auth.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;

  LandingPage({@required this.auth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: auth.onStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          Admin user = snapshot.data;
          if (user == null) {
            return LoginPage(
              auth: auth,
            );
          } else {
            return HomePage(
              auth: auth,
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
