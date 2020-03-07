import 'package:flutter/material.dart';
import 'welcome_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<WelcomeModel> welcomes =
      [
        WelcomeModel(image: "assets/images/welcome.png" , title: " Welcome1 To mohammed Uber " , body:  ' page 1' ),
        WelcomeModel(image: "assets/images/welcome1.jpg" , title: " Welcome2 To mohammed Uber " , body: ' page2 ' ),
        WelcomeModel(image: "assets/images/welcome2.jpg" , title: " Welcome3 To mohammed Uber " , body: ' page3 ' ),
        WelcomeModel(image: "assets/images/welcome3.jpg" , title: " Welcome4 To mohammed Uber " , body: ' page4 ' ),
      ];

  PageController _pageController;
  String nextText ='Next';
  bool amInLastPage = false ;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 1 ,
      viewportFraction: 0.75,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    double radius = MediaQuery.of(context).size.width*0.09;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _slider(context),
          _bottomNavigation(context , radius),
        ],
      ),
    );
  }
  
  Widget _slider(BuildContext context){
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
          padding: EdgeInsets.only(top: 150),
        child: PageView.builder(
          onPageChanged: (position){
            if(position == welcomes.length -1 ){
              setState(() {
                nextText = "Get Started";
                amInLastPage = true;
              });
            }else{
              setState(() {
                nextText = " Next" ;
                amInLastPage = false ;
              });

            }
          },
          controller: _pageController,
          itemCount: this.welcomes.length,
          itemBuilder: (context , position ){
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Image.asset(welcomes[position].image , fit: BoxFit.cover,),
                _pageIndicators(context, position),
                Text(welcomes[0].title),
                Text(welcomes[0].body),
              ],
            ),
          );
        }),
        
      ),
    );
    
  }

  Widget _pageIndicators(BuildContext context , int position) {
    return Row();
  }

  Widget _bottomNavigation(BuildContext context , double radius){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
        ),

        height: MediaQuery.of(context).size.height*0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () async{
                //TODO:  skip
                SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
                onPressed: (){
                  //TODO: go to home page
                  if(amInLastPage){
                    goToHomePage(context);
                  }else{

                  }
                  _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                },
                child: Text(nextText),
              ),
            ),
          ],
        ),
      ),


    );
  }

  void goToHomePage(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {return HomeScreen();}),);
  }
}
