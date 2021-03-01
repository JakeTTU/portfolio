class NumberPad{
  int numberPadSpace;
  int numberPadWidth;
  int numberPadHeight;
  int numberPadX;
  int numberPadY;
  int textSize = 16;
  
  Button[] buttons;
  
  NumberPad(int space, int Width, int Height, int X, int Y){
    numberPadSpace = space;
    numberPadWidth = Width;
    numberPadHeight = Height;
    numberPadX = X - numberPadWidth/2 - (space/2)*2;
    numberPadY = Y - numberPadHeight/2 - (space/2)*3;
    
    buttons = new Button[10];
    
    buttons[0] = new Button(numberPadX, numberPadY, numberPadWidth/3, numberPadHeight/4, "1", textSize);
    buttons[1] = new Button(numberPadX+numberPadWidth/3+numberPadSpace, numberPadY, numberPadWidth/3, numberPadHeight/4, "2", textSize);
    buttons[2] = new Button(numberPadX+(numberPadWidth/3)*2+numberPadSpace*2, numberPadY, numberPadWidth/3, numberPadHeight/4, "3", textSize);
    buttons[3] = new Button(numberPadX, numberPadY+numberPadHeight/4+numberPadSpace, numberPadWidth/3, numberPadHeight/4, "4", textSize);
    buttons[4] = new Button(numberPadX+numberPadWidth/3+numberPadSpace, numberPadY+numberPadHeight/4+numberPadSpace, numberPadWidth/3, numberPadHeight/4, "5", textSize);
    buttons[5] = new Button(numberPadX+(numberPadWidth/3)*2+numberPadSpace*2, numberPadY+numberPadHeight/4+numberPadSpace, numberPadWidth/3, numberPadHeight/4, "6", textSize);
    buttons[6] = new Button(numberPadX, numberPadY+(numberPadHeight/4)*2+numberPadSpace*2, numberPadWidth/3, numberPadHeight/4, "7", textSize);
    buttons[7] = new Button(numberPadX+numberPadWidth/3+numberPadSpace, numberPadY+(numberPadHeight/4)*2+numberPadSpace*2, numberPadWidth/3, numberPadHeight/4, "8", textSize);
    buttons[8] = new Button(numberPadX+(numberPadWidth/3)*2+numberPadSpace*2, numberPadY+(numberPadHeight/4)*2+numberPadSpace*2, numberPadWidth/3, numberPadHeight/4, "9", textSize);
    buttons[9] = new Button(numberPadX+numberPadWidth/3+numberPadSpace, numberPadY+(numberPadHeight/4)*3+numberPadSpace*3, numberPadWidth/3, numberPadHeight/4, "0", textSize);
  }
  
  void render(){
    //for (int i = 0; i<10; i = i+1){
    //  buttons[i].render();
    //}
    for (Button i: buttons){
      i.render();
    }
    
    //buttons[0].render();
    //twoButton.render();
    //threeButton.render();
    //fourButton.render();
    //fiveButton.render();
    //sixButton.render();
    //sevenButton.render();
    //eightButton.render();
    //nineButton.render();
    //zeroButton.render();
  }



}
