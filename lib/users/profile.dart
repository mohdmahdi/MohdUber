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
  bool isDriver = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('profiles')
          .where('user_id', isEqualTo: user.uid)
          .getDocuments()
          .then((documentQuery) {
        String type = documentQuery.documents[0]['type'];
        if (type == 'driver') {
          setState(() {
            isDriver = true;
            user_id = user.uid;
            email = user.email;
            isReady = true;
          });
        }else{
          setState(() {
            user_id = user.uid;
            email = user.email;
            isReady = true;
          });
        }
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
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('First Name'),
              subtitle: Text(snapshot.data.documents[0]['fist_name'] != null
                  ? snapshot.data.documents[0]['fist_name']
                  : "first Name not set"),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileUpdate(
                          'fist_name',
                          snapshot.data.documents[0]['fist_name'],
                          user_id,
                        )));
              },
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: Text(snapshot.data.documents[0]['last_name'] != null
                  ? snapshot.data.documents[0]['last_name']
                  : "Last Name not set"),
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileUpdate('last_name',
                        snapshot.data.documents[0]['last_name'], user_id)));
              },
            ),
            ListTile(
              title: Text('Mobile'),
              subtitle: snapshot.data.documents[0]['mobile'] != null
                  ? Text(snapshot.data.documents[0]['mobile'])
                  : Text('Mobile has not been set '),
              leading: Icon(Icons.phone),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileUpdate(
                        'mobile',
                        snapshot.data.documents[0]['mobile'] != null
                            ? (snapshot.data.documents[0]['mobile'])
                            : null,
                        user_id)));
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
            ... isDriver? _driverProfile(context, snapshot): []
          ],
        ));
  }

  List<Widget> _driverProfile(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return [
      ListTile(
        title: Text('Car Manufacturer'),
        subtitle: snapshot.data.documents[0]['car_manufacturer'] != null
            ? Text(snapshot.data.documents[0]['car_manufacturer'])
            : Text('car manufacturer has not been set '),
        leading: Icon(Icons.account_balance),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileUpdate(
                  'car_manufacturer',
                  snapshot.data.documents[0]['car_manufacturer'] != null
                      ? (snapshot.data.documents[0]['car_manufacturer'])
                      : null,
                  user_id)));
        },
      ),
      ListTile(
        title: Text('Car Model'),
        subtitle: snapshot.data.documents[0]['car_model'] != null
            ? Text(snapshot.data.documents[0]['car_model'])
            : Text('car manufacturer has not been set '),
        leading: Icon(Icons.directions_car),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileUpdate(
                  'car_model',
                  snapshot.data.documents[0]['car_model'] != null
                      ? (snapshot.data.documents[0]['car_model'])
                      : null,
                  user_id)));
        },
      ),
      ListTile(
        title: Text('Car Year'),
        subtitle: snapshot.data.documents[0]['car_year'] != null
            ? Text(snapshot.data.documents[0]['car_year'])
            : Text('car year has not been set '),
        leading: Icon(Icons.calendar_today),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileUpdate(
                  'car_year',
                  snapshot.data.documents[0]['car_year'] != null
                      ? (snapshot.data.documents[0]['car_year'])
                      : null,
                  user_id)));
        },
      ),
    ];
  }
}
