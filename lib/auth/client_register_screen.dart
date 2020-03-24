
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberapp/auth/driver_register_screen.dart';
import 'package:uberapp/auth/login_screen.dart';
import 'package:uberapp/main_theme.dart';
import 'package:uberapp/util/shared_widgets.dart';

class ClientRegisterScreen extends StatefulWidget {
  @override
  _ClientRegisterScreenState createState() => _ClientRegisterScreenState();
}

class _ClientRegisterScreenState extends State<ClientRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  bool _enabled = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _conformPasswordController = TextEditingController();

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
    _conformPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Sign Up'),
      body: Container(
        padding: EdgeInsets.only(left: 18, right: 18, bottom: 32),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 75,
                ),
                TextFormField(
                  enabled: _enabled,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value){
                    if(value.isEmpty){
                      return ' Email is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  enabled: _enabled,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (value){
                    if(value.isEmpty){
                      return ' Password is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  enabled: _enabled,
                  obscureText: true,
                  controller: _conformPasswordController,
                  decoration: InputDecoration(hintText: 'Confirm Password '),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Confirm password is Required';
                    }
                    if(_passwordController.text != value){
                      return 'Your Password do not Match';
                    }
                    return null;
                  },
                ),
                _signUpButton(context),
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
                _driverButton(context),
              ],
            )),
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
  Widget _signUpButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: FlatButton(

        child: _enabled? Text('Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            )) : CircularProgressIndicator(backgroundColor: Colors.white,),
        onPressed: () {
          //check state
          if(_enabled){
            if(!_formKey.currentState.validate()){
              setState(() {
                _formAutoValidation = true;
              });
            }else {
              //TODO: Make the call
              _createUserAccount();
            }
          }
        },
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }

  Widget _driverButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: FlatButton(
        child: Text('Create Driver Account',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DriverRegisterScreen(),),);
        },
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
    );
  }


  void _enableSubmitting(){
    setState(() {
      _enabled = false;
    });
  }

  void _setAccountDetails(){
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
    });
  }



  void _createUserAccount (){
    _enableSubmitting();
    _setAccountDetails();
    //TODO: call FireBase and create user account
  }
}
