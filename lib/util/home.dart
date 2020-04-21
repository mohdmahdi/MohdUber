import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uberapp/auth/login_screen.dart';
import 'package:uberapp/users/profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color _grey = Color(0xFF636363);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: _grey
        ),
        title: Text(
          'Home',
          style: TextStyle(
              color: _grey,
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(),
            ListTile(
              onTap: ()async{
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Profile()));
             },
              trailing: Icon(Icons.person),
              title: Text('PROFILE'),
            ),
            ListTile(
              onTap: ()async{
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) =>LoginScreen()));
              },
              trailing: Icon(Icons.exit_to_app),
              title: Text('LOGOUT'),
            )
          ],
        ),
      ),
      body: Center(
          child: Text('HOME SCREEN'),
      ),
    );
  }
}
