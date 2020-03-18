import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget appBar(BuildContext context , String title){
  return AppBar(
    title: Text(title , style: Theme.of(context).textTheme.title,),
    backgroundColor: Colors.transparent,
    elevation:  0,

  );
}
Widget  divider(BuildContext context){
  return Container(height: 1, color: Colors.grey.shade300);
}