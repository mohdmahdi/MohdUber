import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uberapp/auth/client_register_screen.dart';
import 'welcome_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class WelcomeScreen3 extends StatefulWidget {
  @override
  _WelcomeScreen3State createState() => _WelcomeScreen3State();
}

class _WelcomeScreen3State extends State<WelcomeScreen3> {
  List<WelcomeModel> welcomes = [
    WelcomeModel(
        image: "assets/images/welcome.png",
        title: " Download ,call , go  ",
        body:
        ' This is first  long sentences genral can be modified by you at any time with watever words '),
    WelcomeModel(
        image: "assets/images/welcome1.jpg",
        title: " Welcome 2  Mohd ",
        body:
        ' This is second  long sentences genral can be modified by you at any time with watever words '),
    WelcomeModel(
        image: "assets/images/welcome2.jpg",
        title: " Welcome 3 To  Uber ",
        body:
        ' This is third long sentences genral can be modified by you at any time with watever words '),
    WelcomeModel(
        image: "assets/images/welcome3.jpg",
        title: " Welcome 4 To  Uber ",
        body:
        ' This is forth long sentences genral can be modified by you at any time with watever words '),
  ];

  PageController _imageController;
  PageController _textController;
  String nextText = 'Next';
  bool amInLastPage = false;

  int _currentPosition = 0;
  int mainPosition = 0;

  @override
  void initState() {
    super.initState();


    _textController = PageController(initialPage: 0,viewportFraction: 1 );
    _imageController = PageController(initialPage: 0 , viewportFraction: 0.75);
    //..addListener(_onImageScroll);
  }

  @override
  void dispose() {
    _imageController.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.09;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _slider(context),
          _slider2(context),
          Align(
              alignment: Alignment.bottomCenter,
              child: _pageIndicators(context, _currentPosition)),
          _bottomNavigation(context, radius),
        ],
      ),
    );
  }

  Widget _slider(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 40),
        child: PageView.builder(
            onPageChanged: (position) {
              mainPosition = position;
              setState(() {
                _currentPosition = position;
              });
              if (position == welcomes.length - 1) {
                setState(() {
                  nextText = "Get Started";
                  amInLastPage = true;
                });
              } else {
                setState(() {
                  nextText = " Next";
                  amInLastPage = false;
                });
              }
            },
            controller: _imageController,
            itemCount: this.welcomes.length,
            itemBuilder: (context, position) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      welcomes[position].image,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),

                  ],
                ),
              );
            }),
      ),
    );
  }
  Widget _slider2(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 380),
        child: PageView.builder(
            onPageChanged: (position) {
              mainPosition = position;
              setState(() {
                _currentPosition = position;
              });
              if (position == welcomes.length - 1) {
                setState(() {
                  nextText = "Get Started";
                  amInLastPage = true;
                });
              } else {
                setState(() {
                  nextText = " Next";
                  amInLastPage = false;
                });
              }
            },
            controller: _textController,
            itemCount: this.welcomes.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, position) {
              position = mainPosition;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 48,
                    ),
                    Text(
                      welcomes[position].title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      welcomes[position].body,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subhead.copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }


  Widget _pageIndicators(BuildContext context, int position) {
    double offset = MediaQuery.of(context).size.height * 0.35;
    return Transform.translate(
      offset: Offset(0, -offset),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _newPageIndicators(),
      ),
    );
  }

  List<Widget> _newPageIndicators() {
    List<Widget> widgets = [];
    for (int i = 0; i < welcomes.length; i++) {
      widgets.add(_pageIndicator(
        (_currentPosition == i
            ? Theme.of(context).primaryColor
            : Color(0xFFEFDC99)),
        (i == welcomes.length - 1 ? 0 : 12),
      ));
    }

    return widgets;
  }

  Widget _pageIndicator(Color color, double margin) {
    return Container(
      width: 15,
      height: 5,
      margin: EdgeInsets.only(right: margin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }

  Widget _bottomNavigation(BuildContext context, double radius) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius)),
        ),
        height: MediaQuery.of(context).size.height * 0.10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                //TODO:  skip
                SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
                sharedPreferences.setBool('seen', true);
                goToHomePage(context);
              },
              child: Text('Skip'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: MaterialButton(
                minWidth: 150,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
                onPressed: () {
                  //TODO: go to home page
                  if (amInLastPage) {
                    goToHomePage(context);
                  } else {}
                  _imageController.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
                child: Text(nextText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return ClientRegisterScreen();
      }),
    );
  }

  _onImageScroll() {
    _textController.animateTo(_imageController.offset,
        duration: Duration(milliseconds: 150), curve: Curves.decelerate);
  }
}
