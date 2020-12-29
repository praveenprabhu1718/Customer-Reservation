import 'package:customer_reservation_app/app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  final AuthBase auth;

  const LoginPage({Key key, this.auth}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showSpinner = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  Future<void> _signInWithEmailAndPassword() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    setState(() {
      _showSpinner = true;
    });
    try {
      await widget.auth.signInWithEmailAndPassword(_email, _password);
    } catch (e) {
      setState(() {
        _showSpinner = false;
      });
      final snackBar = SnackBar(
        content: Text('Invalid Email or Password'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    setState(() {
      _showSpinner = false;
    });
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  InkWell _loginButton(BuildContext context) {
    return InkWell(
      onTap: _signInWithEmailAndPassword,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.075,
          width: MediaQuery.of(context).size.width * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: primaryColor,
          ),
          child: Center(
            child: Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _passwordField() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          border: border,
          focusedBorder: focusedBorder,
          labelText: 'Password',
          labelStyle: TextStyle(
              color: _passwordFocusNode.hasFocus ? primaryColor : Colors.grey),
        ),
        autocorrect: false,
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _signInWithEmailAndPassword,
      ),
    );
  }

  Container _emailField() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: TextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        cursorColor: primaryColor,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditingComplete,
        decoration: InputDecoration(
            border: border,
            focusedBorder: focusedBorder,
            labelText: 'Email',
            labelStyle: TextStyle(
                color: _emailFocusNode.hasFocus ? primaryColor : Colors.grey),
            hintText: 'admin@admin.com'),
      ),
    );
  }

  Padding _adminText() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Admin Login',
          style: GoogleFonts.titilliumWeb(
              fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Container _adminLogo(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Image.asset(
            'assets/admin.png',
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ModalProgressHUD(
      color: primaryColor,
      inAsyncCall: _showSpinner,
      child: Column(
        children: [
          Flexible(
            flex: 4,
            child: _adminLogo(context),
          ),
          Flexible(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(child: _adminText()),
                  SizedBox(height: 8),
                  Flexible(child: _emailField()),
                  SizedBox(height: 8),
                  Flexible(child: _passwordField()),
                  SizedBox(height: 8),
                  Flexible(child: _loginButton(context))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _buildContent(context),
    );
  }
}
