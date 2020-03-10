import 'dart:convert';

import 'package:flutter/material.dart';
import 'welcome_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<WelcomeModel> welcomes = [
    WelcomeModel(
        image: "assets/images/welcome.png",
        title: " Download ,call , go  ",
        body:
            ' This is first  long sentences genral can be modified by you at any time with watever words '),
    WelcomeModel(
        image: "assets/images/welcome1.jpg",
        title: " Welcome 2  Uber ",
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

  PageController _pageController;
  String nextText = 'Next';
  bool amInLastPage = false;

  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.75,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width * 0.09;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _slider(context),
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
        padding: EdgeInsets.only(top: 110),
        child: PageView.builder(
            onPageChanged: (position) {
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
            controller: _pageController,
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
    double offset = MediaQuery.of(context).size.height * 0.30;
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
                  _pageController.nextPage(
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return HomeScreen();
      }),
    );
  }
}
