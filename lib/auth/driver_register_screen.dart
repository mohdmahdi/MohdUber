import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberapp/auth/client_register_screen.dart';
import 'package:uberapp/util/home.dart';
import 'package:uberapp/util/shared_widgets.dart';


import 'login_screen.dart';

class DriverRegisterScreen extends StatefulWidget {
  @override
  _DriverRegisterScreenState createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends State<DriverRegisterScreen> {
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  String _manufacturer;
  String _carModel;
  String _carYear;

  bool _enabled = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _manufacturerController = TextEditingController();
  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carYearController = TextEditingController();

  PageController _pageController = PageController();

  bool _formAutoValidation = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _manufacturerController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Sign Up as driver'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          autovalidate: _formAutoValidation,
          key: _formKey,
          child: Column(
            children: <Widget>[
              Flexible(
                child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    _userNamePage(context),
                    _carDetails(context),
                  ],
                ),
              ),
              Row(
                children: <Widget>[],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _or(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(child: divider(context),),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Flexible(child: divider(context),),
      ],
    );
  }
  Widget _userNamePage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 75,
        ),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(hintText: 'Email'),
          validator: (value) {
            if (value.isEmpty) {
              return 'Email is Required';
            }
            return null;
          },
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(hintText: 'Password'),
          validator: (value) {
            if (value.isEmpty) {
              return 'password is Required';
            }
            return null;
          },
        ),
        TextFormField(
          obscureText: true,
          controller: _confirmPasswordController,
          decoration: InputDecoration(hintText: 'Confirm Password '),
          validator: (value) {
            if (value.isEmpty) {
              return 'Confirm password is Required';
            }
            if (_passwordController.text != value) {
              return 'Your Password do not Match';
            }
            return null;
          },
        ),
        Container(
          height: 50,
          width: double.infinity,
          child: FlatButton(
            child: Text('Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                )),
            onPressed: () {
              if (!_formKey.currentState.validate()) {
                setState(() {
                  _formAutoValidation = true;
                });
              } else {
                //save date
                _setAccountDetails();
                //move to next page
                _nextPage();
              }
            },
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
          ),
        ),
        Row(
          children: <Widget>[
            Text('Already Member? '),
            FlatButton(
              child: Text(
                'Sign In',
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
        _or(context),
        _clientSignUpButton(context),
      ],
    );
  }

  Widget _clientSignUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(

        child: _enabled? Text('Create Client Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )) : CircularProgressIndicator(backgroundColor: Colors.white,),
        onPressed: () {
          //check state
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ClientRegisterScreen(),),);
        },
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }

  Widget _carDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 75,
        ),
        TextFormField(
          enabled: _enabled,
          controller: _manufacturerController,
          decoration: InputDecoration(hintText: 'Car Manufacturer'),
          validator: (value) {
            if (value.isEmpty) {
              return ' Cam Manufacturer is required';
            }
            return null;
          },
        ),
        TextFormField(
          enabled: _enabled,
          controller: _carModelController,
          decoration: InputDecoration(hintText: 'Car Model'),
          validator: (value) {
            if (value.isEmpty) {
              return ' Cam Model is required';
            }
            return null;
          },
        ),
        TextFormField(
          enabled: _enabled,
          controller: _carYearController,
          decoration: InputDecoration(hintText: 'Car Year '),
          validator: (value) {
            if (value.isEmpty) {
              return ' Cam Year is required';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: FlatButton(
                child: Text('BACK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    )),
                onPressed: () {
                  _prevPage();
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
            Flexible(
              child: FlatButton(
                child: _enabled
                    ? Text('SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ))
                    : SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator()),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    setState(() {
                      _formAutoValidation = true;
                    });
                  } else {
                    if (_enabled) {
                      setState(() {
                        _enabled = false;
                      });
                    }

                    _setCarDetails();
                    //TODO : MAKE THE CALL
                    _createDriverAccount();
                  }
                },
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('Already Member? '),
            FlatButton(
              child: Text(
                'Sign In',
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
      ],
    );
  }

  void _nextPage() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _prevPage() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _setAccountDetails() {
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
    });
  }

  void _setCarDetails() {
    setState(() {
      _manufacturer = _manufacturerController.text;
      _carModel = _carModelController.text;
      _carYear = _carYearController.text;
    });
  }

  void _createDriverAccount() async {
      AuthResult _authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
      FirebaseUser _user = _authResult.user;
    if(_user != null) {
      SharedPreferences _sharedPref = await SharedPreferences.getInstance();
      _sharedPref.setString('user_id', _user.uid);

      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((value){
        Firestore.instance.collection('profiles').document().setData({
          'user_id': _user.uid,
          'type': 'driver',
          'car_year' : _carYear,
          'car_manufacturer' :_manufacturer,
          'car_model' : _carModel,
        }).then((value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      });

    }
  }
}
