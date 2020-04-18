import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uberapp/users/profile_update.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user_id;
  bool isReady = false;
  String email;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        user_id = user.uid;
        email = user.email;
        isReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isReady
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('profiles')
                  .where('user_id', isEqualTo: user_id)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return error('no connection made');
                    break;
                  case ConnectionState.waiting:
                    return loading();
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return error(snapshot.error.toString());
                    }
                    if (!snapshot.hasData) {
                      return error('no data ');
                    }
                    return profileForm(context, snapshot);
                    break;
                  default:
                    return error('nothing is here ');
                    break;
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget error(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget profileForm(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data.documents.length == 0 ||
        snapshot.data.documents.length == null) {
      return error('no data for that user id ');
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32 , vertical: 16),
        child: ListView(
      children: <Widget>[
        ListTile(
          title: Text('First Name'),
          subtitle: Text(snapshot.data.documents[0]['fist_name']),
          leading: Icon(Icons.person),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileUpdate('fist_name' , snapshot.data.documents[0]['fist_name'] , user_id)
            ));
          },
        ),
        ListTile(
          title: Text('Last Name'),
          subtitle: Text(snapshot.data.documents[0]['last_name']),
          leading: Icon(Icons.person),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileUpdate('last_name' , snapshot.data.documents[0]['last_name'] , user_id)
            ));
          },
        ),
        ListTile(
          title: Text('Mobile'),
          subtitle: snapshot.data.documents[0]['mobile'] != null
              ? Text(snapshot.data.documents[0]['mobile'])
              : Text('Mobile has not been set '),
          leading: Icon(Icons.phone),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileUpdate('mobile' , snapshot.data.documents[0]['mobile'] != null
                    ? (snapshot.data.documents[0]['mobile'])
                    : null , user_id)
            ));
          },
        ),
        ListTile(
          title: Text('Email'),
          subtitle: Text(email),
          leading: Icon(Icons.email),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        ListTile(
          title: Text('Password'),
          subtitle: Text('********'),
          leading: Icon(Icons.lock),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    ));
  }
}
