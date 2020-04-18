import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileUpdate extends StatefulWidget {
  String firestoreKey;
  String firestoreValue;
  String user_id ;


  ProfileUpdate(this.firestoreKey, this.firestoreValue, this.user_id);

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  TextEditingController _valueController = TextEditingController();
  var _key = GlobalKey<FormState>();
  bool autoValidate = false;

  @override
  void initState() {
    if(widget.firestoreValue == null ){
      _valueController.text = '';
    }else{
      _valueController.text = widget.firestoreValue;
    }

    super.initState();
  }
  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Form(
          autovalidate: autoValidate,
          key: _key,
            child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return 'You need to eneter the Value for ' + widget.firestoreKey;
                }
                return null;
              },
              controller: _valueController,
              decoration: InputDecoration(
                labelText: widget.firestoreKey.toUpperCase(),
              ),
            ),
            SizedBox(height: 32,),
            RaisedButton(
              onPressed: () async{
                if(_key.currentState.validate()){
                  Firestore.instance.collection('profiles').where('user_id' , isEqualTo: widget.user_id).getDocuments().then((documentQuery){
                    Firestore.instance.collection('profiles').document(documentQuery.documents[0].documentID).updateData({
                      widget.firestoreKey : _valueController.text
                    }).then((value){
                    Navigator.of(context).pop();
                    });
                  });
                }else{
                  setState(() {
                    autoValidate = true;
                  });
                }
              },
              child: Text('UPDATE'),
            ),
          ],
        )),
      ),
    );
  }
}
