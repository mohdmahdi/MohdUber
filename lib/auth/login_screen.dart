import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberapp/auth/client_register_screen.dart';
import 'package:uberapp/util/home.dart';
import 'package:uberapp/util/shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _enabled;
  bool _autoValidation = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sharedPref) {
      sharedPref.setBool('seen', true);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Sign In'),
      body: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
        child: Form(
            autovalidate: _autoValidation,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 65,
                ),
                TextFormField(
                  controller: _emailController,
                  enabled: _enabled,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' Email is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  enabled: _enabled,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return ' password is required';
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(),
                    ),
                    FlatButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        'Forgotten Password ?',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                    ),
                  ],
                ),
                _signInButton(context),
                _or(context),
                _signUpButton(context),
              ],
            )),
      ),
    );
  }

  Widget _or(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: divider(context)),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Flexible(child: divider(context)),
      ],
    );
  }

  Widget _signUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(
        child: Text('Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ClientRegisterScreen(),
          ));
        },
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }

  Widget _signInButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        onPressed: _signIn,
        child: Text(
          'Sign In',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }

  void _setAccountDetails() {
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
    });
  }

  void _signIn() async {
    _setAccountDetails();
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
      });
    } else {
      setState(() {
        _enabled = false;
      });
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email, password: _password).then((user) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((error) {
        setState(() {
          _enabled = true;
        });
        _wrongLogins(context, "Login Failed , please check again");
      });
    }
  }

  Future<void> _wrongLogins(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: SingleChildScrollView(
            child: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
