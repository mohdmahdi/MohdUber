import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uberapp/auth/login_screen.dart';
import 'package:uberapp/util/welcomeSeperatedPV.dart';
import 'auth/client_register_screen.dart';
import 'util/welcome.dart';
import 'util/home.dart';
import 'package:uberapp/main_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool seen = sharedPreferences.getBool('seen');
  Widget homeScreen = HomeScreen();
  if(seen == null || !seen){
    homeScreen = WelcomeScreen3();
  }else{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.currentUser();
    if(user==null) {
      homeScreen = LoginScreen();
    }
  }

  runApp(Wadini(homeScreen));
}
class Wadini extends StatelessWidget {
  final Widget homeScreen;
  Wadini(this.homeScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: this.homeScreen,
      theme: mainTheme,
    );
  }
}

