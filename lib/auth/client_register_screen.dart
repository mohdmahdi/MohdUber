
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberapp/auth/driver_register_screen.dart';
import 'package:uberapp/auth/login_screen.dart';
import 'package:uberapp/main_theme.dart';
import 'package:uberapp/util/home.dart';
import 'package:uberapp/util/shared_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientRegisterScreen extends StatefulWidget {
  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  String _email;
  String _password;
  String _confirmPassword;
  String _firstName;
  String _lastName;


  bool _enabled = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();


  PageController _pageController = PageController();

  bool _formAutoValidation = false ;

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
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Sign Up as client'),
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
                    _userDetails(context),
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

  void _enableSubmitting(){
    setState(() {
      _enabled = false;
    });
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
        _driverSignUpButton(context),
      ],
    );
  }

  Widget _driverSignUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(

        child: _enabled? Text('Create Driver Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )) : CircularProgressIndicator(backgroundColor: Colors.white,),
        onPressed: () {
          //check state
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DriverRegisterScreen(),),);
        },
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }

  Widget _userDetails(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 75,
        ),
        TextFormField(
          enabled: _enabled,
          controller: _firstNameController,
          decoration: InputDecoration(hintText: 'First Name'),
          validator: (value) {
            if (value.isEmpty) {
              return ' First Name is required';
            }
            return null;
          },
        ),
        TextFormField(
          enabled: _enabled,
          controller: _lastNameController,
          decoration: InputDecoration(hintText: 'Last Name'),
          validator: (value) {
            if (value.isEmpty) {
              return ' Last Name is required';
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
                    _setUserDetails();
                    //TODO : MAKE THE CALL
                    _createUserAccount();
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
      _firstName = _firstNameController.text;
      _lastName = _lastNameController.text;
    });
  }

  void _setUserDetails() {
    setState(() {
      _firstName = _firstNameController.text;
      _lastName = _lastNameController.text;
    });
  }

  void _createUserAccount () async{
    _enableSubmitting();
    _setAccountDetails();
    //TODO: call FireBase and create user account
    AuthResult _authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
    FirebaseUser _user = _authResult.user;
    if(_user != null) {
      SharedPreferences _sharedPref = await SharedPreferences.getInstance();
      _sharedPref.setString('user_id', _user.uid);

      _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password).then((value){
        _firestore.collection('profiles').document().setData({
          'user_id': _user.uid,
          'type': 'customer',
          'fist_name' : _firstName,
          'last_name' :_lastName,
        }).then((value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      });

    }
  }


}
