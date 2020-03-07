import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'util/welcome.dart';
import 'util/home.dart';
import 'package:uberapp/main_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool seen = sharedPreferences.getBool('seen');
  Widget homeScreen = HomeScreen();
  if(seen == null || !seen){
    homeScreen = WelcomeScreen();
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

