import 'package:flutter/material.dart';
enum ScreenType{
  SMALL, MEDIUM , LARGE
}

class ScreenConfig{
  BuildContext context;
  double screenWidth;
  double screenHeight;
  ScreenType screenType;

  ScreenConfig(BuildContext context){
    this.screenWidth  = MediaQuery.of(context).size.width;
    this.screenHeight = MediaQuery.of(context).size.height;
    print(this.screenWidth);
    _setScreen();
  }

 void _setScreen(){
    if(this.screenWidth >= 320 && this.screenWidth < 360) {
      this.screenType = ScreenType.SMALL;
    }
    if(this.screenWidth >= 360 && this.screenWidth <= 414) {
      this.screenType = ScreenType.MEDIUM;
    }
    if(this.screenWidth > 414) {
      this.screenType = ScreenType.LARGE;
    }
 }
}
class WidgetSize{
  double titleFontSize;
  double descriptionFontSize;
  double pagerDotsWidth;
  double pagerDotsHeight;
  double buttonHeight;
  double buttonWidth;
  double buttonFontSize;
  double multiplier;
  double imageHeight;
  double welcomePadding;
  double indicatorOffset;
  ScreenConfig screenConfig;

  WidgetSize( ScreenConfig screenConfig){
    this.screenConfig = screenConfig;
    _init();
  }
void _init(){

    switch(this.screenConfig.screenType){
      case ScreenType.SMALL :
        this.titleFontSize = 14;
        this.descriptionFontSize = 12;
        this.pagerDotsWidth = 25;
        this.pagerDotsHeight = 4;
        this.buttonFontSize = 16;
        this.buttonHeight = 40;
        this.buttonWidth = 240;
        this.multiplier = 0.05;
        this.imageHeight = 0.4;
        this.welcomePadding = 320;
        this.indicatorOffset = 0.41;
        break;
      case ScreenType.MEDIUM :
        this.titleFontSize = 20;
        this.descriptionFontSize = 18;
        this.pagerDotsWidth = 35;
        this.pagerDotsHeight = 6;
        this.buttonFontSize = 22;
        this.buttonHeight = 60;
        this.buttonWidth = 240;
        this.imageHeight = 0.5;
        this.welcomePadding = 400;
        this.indicatorOffset = 0.35;
        break;
      case ScreenType.LARGE :
        this.titleFontSize = 22;
        this.descriptionFontSize = 20;
        this.pagerDotsWidth = 35;
        this.pagerDotsHeight = 4;
        this.buttonFontSize = 22;
        this.buttonHeight = 60;
        this.buttonWidth = 240;
        this.imageHeight = 0.50;
        this.welcomePadding = 560;
        this.indicatorOffset = 0.35;
        break;
      default:
        this.titleFontSize = 28;
        this.descriptionFontSize = 20;
        this.pagerDotsWidth = 35;
        this.pagerDotsHeight = 6;
        this.buttonFontSize = 16;
        this.buttonHeight = 40;
        this.buttonWidth = 40;
        this.buttonFontSize = 22;
        this.buttonHeight = 60;
        this.buttonWidth = 240;
        this.multiplier = 0.05;
        this.imageHeight = 0.5;
        this.welcomePadding = 380;
        this.indicatorOffset = 0.35;
        break;

  }
  }

}