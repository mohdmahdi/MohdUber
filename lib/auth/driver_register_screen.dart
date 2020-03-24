import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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


  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _manufacturerController = TextEditingController();
  TextEditingController _carModelController = TextEditingController();
  TextEditingController _carYearController = TextEditingController();

  PageController _pageController = PageController();

  bool _formAutoValidation = false ;

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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          autovalidate: _formAutoValidation ,
          key: _formKey,
          child:Column(
            children: <Widget>[
              Flexible(
                child: PageView(
                  controller:_pageController ,
                  children: <Widget>[
                    _userNamePage(context),
                    _carDetails(context),
                  ],
                ),
              ),
              Row(
                children: <Widget>[

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userNamePage(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 75,
        ),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(hintText: 'Email'),
          validator: (value){
            if(value.isEmpty){
             return 'Email is Required';
            }
            return null;
          },
        ),
        TextFormField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(hintText: 'Password'),
          validator: (value){
            if(value.isEmpty){
              return 'password is Required';
            }
            return null;
          },
        ),
        TextFormField(

          obscureText: true,
          controller: _confirmPasswordController,
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
              if(!_formKey.currentState.validate()){
                setState(() {
                  _formAutoValidation = true;
                });
              }else {
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
      ],
    );

  }

  Widget _carDetails(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          height: 75,
        ),
        TextFormField(
          controller: _manufacturerController,
          decoration: InputDecoration(hintText: 'Car Manufacturer'),
          validator: (value){
            if(value.isEmpty){
              return ' Cam Manufacturer is required';
            }
            return null;
        },
        ),
        TextFormField(
          controller: _carModelController,
          decoration: InputDecoration(hintText: 'Car Model'),
          validator: (value){
            if(value.isEmpty){
              return ' Cam Model is required';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _carYearController,
          decoration: InputDecoration(hintText: 'Car Year '),
          validator: (value){
            if(value.isEmpty){
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
                child: Text('SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    )),
                onPressed: () {
                  if(!_formKey.currentState.validate()){
                    setState(() {
                      _formAutoValidation = true;
                    });
                  }else{
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
        ],),
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

  void _nextPage(){
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _prevPage(){
    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _setAccountDetails(){
    setState(() {
      _email = _emailController.text;
      _password = _passwordController.text;
    });
  }

  void _setCarDetails(){
    setState(() {
      _manufacturer = _manufacturerController.text;
      _carModel = _carModelController.text;
      _carYear = _carYearController.text;
    });

  }

  void _createDriverAccount(){
  //TODO: Call firebase to create driver account
  }


}
