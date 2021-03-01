import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Microwave extends PApplet {


float start2 = PI*1.5f;
float end2;

float end = PI*1.5f;
float start = end;

int time_entered;
int start_time;

char[] disp = {' ', ' ', ' ', ' ', ' '};
String time;
int timeInputs = 0;
Boolean timerOn = false;
Boolean flashed = false;
Boolean doorOpen = false;
Boolean doorPrompt = false;
Boolean cookDone = false;
Boolean cooking = false;
Boolean changePower = false;


int flashCount = 0;

NumberPad numberPad;
Button startButton;
Button stopButton;
Button doorButton;
Timer timer;
SoundFile buttonBeep;
SoundFile startCook;
SoundFile endBeep;
SoundFile openDoor;
SoundFile closeDoor;
Slider power;


public void setup(){
  
  numberPad = new NumberPad(6, width/3, height/4, width/2, height/2+height/8);
  startButton = new Button(width/2-40-50, 500, 80, 40, "Start\n+30sec",12);
  stopButton = new Button(width/2-40+50, 500, 80, 40, "Stop\nClear",12);
  doorButton = new Button(width/12, height/2-height/4-height/8-20, width/14, height/2+height/4, "Door\nHandle", 12);
  timer = new Timer(0,0,false);
  power = new Slider(width/2-width/6-5, height/3+height/12+5, width/3+8, 30);
  buttonBeep = new SoundFile(this, "buttonBeep.mp3");
  startCook = new SoundFile(this, "startCooking.mp3");
  endBeep = new SoundFile(this, "endBeep.mp3");
  openDoor = new SoundFile(this, "openDoor.mp3");
  closeDoor = new SoundFile(this, "closeDoor.mp3");
  //disp1 = new char[2];
  
  //disp2 = new char[2];
}

public void draw(){
  background(248);
  stroke(255);
  numberPad.render();
  startButton.render();
  stopButton.render();
  doorButton.render();
  power.render();
  
  fill(50,50,50,20);
  strokeWeight(5);
  stroke(50,50,50,150);
  rect(width/2-100, height/4-100, 200, 200, 20);
  
  int hourTime = hour();
  if (hourTime > 12){
    hourTime = hourTime - 12;
  }
  
  String hourTimeS = str(hourTime);
  int minTime = minute();
  String minTimeS;
  if (minTime < 10){
    minTimeS = "0" + str(minTime);
  }
  else{
    minTimeS = str(minTime);
  }
  time = hourTimeS + ":" + minTimeS;
  
  display();
  circleFunction();
  
  
}

public void promptCloseDoor(){
  doorPrompt = true;
  display();
}

public void mousePressed() {
  for (Button i : numberPad.buttons){
    if (i.rectOver) {
      buttonBeep.play();
      char c = i.Text.charAt(0);
      if (timeInputs == 0){
        disp[0] = '0';
        disp[1] = '0';
        disp[2] = ':';
        disp[3] = '0';
        disp[4] = c;
        timeInputs++;
      }
      else if(timeInputs == 1){
        disp[0] = '0';
        disp[1] = '0';
        disp[2] = ':';
        disp[3] = disp[4];
        disp[4] = c;
        timeInputs++;
      }
      else if(timeInputs == 2){
        disp[0] = '0';
        disp[1] = disp[3];
        disp[2] = ':';
        disp[3] = disp[4];
        disp[4] = c;
        timeInputs++;
      }
      else if(timeInputs == 3) {
        disp[0] = disp[1];
        disp[1] = disp[3];
        disp[2] = ':';
        disp[3] = disp[4];
        disp[4] = c;
        timeInputs++;
      }

      
    }
  }
  if (startButton.rectOver){
    if(!timer.timerEnded){
      startTime();
    }
    else if (doorOpen){
      promptCloseDoor();
    }
  }
  if (stopButton.rectOver){
    buttonBeep.play();
    stopFunc();
  }
  if (doorButton.rectOver){
    doorFunc();
  }  
}

public void mouseDragged(){
  if (power.rectOver && !timerOn){
    power.changePower(mouseX);
    changePower = true;
  }
  else changePower = false;
}

public void stopFunc(){
  if (timer.paused){
    for (int i = 0; i < disp.length; i++){
      disp[i] = ' ';
      timerOn = false;
      timer.timerEnded = false;
      timeInputs = 0;
      flashCount = 0;
      stopCookSound();
      cooking = false;
    }
  } 
  else{
    timer.pause();
    stopCookSound();
    cooking = false;
  }

}

public void startTimer(int timeEntered, int startTime){
  if (!timerOn){
    timer = new Timer(timeEntered, startTime, true);
    timerOn = true;
    cooking = true;
    playCookSound();
  }
  
}

public void startTime(){
  if (doorOpen){
    buttonBeep.play();
    promptCloseDoor();
  }
  else if(cooking){
    buttonBeep.play();
    timer.time_entered = timer.time_entered + 30;
  }
  else{
    if(timer.paused){
      timer.unpause();
      playCookSound();
      cooking = true;
    }
    
    if (!timer.paused){
      int start_s = second();
      int start_m = minute();
      int digit1 = 0;
      int digit2 = 0;
      int digit3 = 0;
      int digit4 = 0;
      //int start_h = hour();
      start_time = start_m*60 + start_s;
      
      if (Character.getNumericValue(disp[4]) >= 1){
        digit1 = Character.getNumericValue(disp[4]);
      }
      if (Character.getNumericValue(disp[3]) >= 1){
        digit2 = Character.getNumericValue(disp[3])*10;
      }
      if (Character.getNumericValue(disp[1]) >= 1){
        digit3 = Character.getNumericValue(disp[1])*60;
      }
      if (Character.getNumericValue(disp[0]) >= 1){
        digit4 = Character.getNumericValue(disp[0])*600;
      }
      
      
      time_entered = digit1 + digit2 + digit3 + digit4;
      if(time_entered == 0){
        time_entered = time_entered + 30;
      }
      startTimer(time_entered, start_time);
    }
  
  }
}

public void circleFunction(){
  float per_done = timer.percentDone();
  if (timerOn){
    if (!timer.timerEnded){
      start = end-((PI*2)*(per_done));
      end2 = (PI*2)-((PI*2)*(per_done))+start2;
      
      strokeWeight(5);
      stroke(211, 64, 24);
      noFill();
      arc(width/2, height/4, 150, 150, start2, end2);
    
      strokeWeight(15);
      stroke(24, 211, 64);
      noFill();
      arc(width/2, height/4, 150, 150, start, end);
    
      
    }
    else if(timer.timerEnded && second() % 2 == 0 && flashCount < 3){
      strokeWeight(15);
      stroke(24, 211, 64);
      noFill();
      arc(width/2, height/4, 150, 150, PI*1.5f, PI*3.5f);
    }
    else if (flashCount == 3){
      strokeWeight(15);
      stroke(24, 211, 64);
      noFill();
      arc(width/2, height/4, 150, 150, PI*1.5f, PI*3.5f);
    }
  }
}

public String formatTimeRamaining(){
  int time_remaining = timer.timeRemaining();
  char [] disp = {' ', ' ', ':', ' ', ' '};
  String s4 = String.valueOf(time_remaining % 10);
  String s3 = String.valueOf(time_remaining/10 % 6);
  String s1 = String.valueOf((time_remaining/60) % 10);
  String s0 = String.valueOf((time_remaining/600) % 10);
  disp[0] = s0.charAt(0);
  disp[1] = s1.charAt(0);
  disp[3] = s3.charAt(0);
  disp[4] = s4.charAt(0);
  
  String s = String.valueOf(disp);
  
  return s;

}

public String timerDone(){ 
  cookDone = true;
  cooking = false;
  int sec = second()*3;
  if (sec % 2 == 0 && flashCount < 3){
    stopCookSound();
    if (!flashed){
      endBeep.play();
      flashCount++;
      flashed = true;
    }
    return "DONE";
  }
  else if (sec % 2 == 1 && flashCount < 3){
    flashed = false;
    return ""; 
  }
  else return "DONE";
}

public void display(){
  String s;
  if(doorPrompt){
    s = "Close\nDoor"; 
  }
  else if (changePower){
    s = power.getPower();
  }
  else if ((!timerOn) && timeInputs == 0){
    s = time;
  }
  else if(timerOn && !timer.timerEnded){
    s = formatTimeRamaining();
  }
  else if(timer.timerEnded){
    s = timerDone();
  }
  
  else{
    s = String.valueOf(disp);
  }
  textAlign(CENTER, CENTER);
  textSize(28);
  fill(0);
  text(s, width/2, height/4);
}

public void playCookSound(){
  if(!startCook.isPlaying()){
    startCook.play();
  }
}

public void stopCookSound(){
  if(startCook.isPlaying()){
    startCook.stop();
  }
}

public void doorFunc(){
  if (!doorOpen){
    openDoor.play();
    doorOpen = true;
    cooking = false;
    if (cookDone){
      clearWithDoor();
    }
    if (timerOn){
      timer.pause();
      stopCookSound();
    }
  }
  else{
    closeDoor.play();
    doorOpen = false;
    doorPrompt = false;
  }
  
}

public void clearWithDoor(){
  for (int i = 0; i < disp.length; i++){
      disp[i] = ' ';
      timerOn = false;
      timer.timerEnded = false;
      timeInputs = 0;
      flashCount = 0;
      cookDone = false;
    }

}
class Button{
  int rectX, rectY;      // Position of square button
  int rectWidth, rectHeight;     // Diameter of rect
  boolean rectOver = false;
  int rectColor = color(50);
  int rectHighlight = color(100);
  int currentColor, baseColor;
  String Text;
  int textSize;
  
  Button(int x, int y, int w, int h, String t, int ts){
    rectX = x;
    rectY = y;
    rectWidth = w;
    rectHeight = h;
    Text = t;
    textSize = ts;
  }
  
  public boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  public void update(int x, int y) {
    if (overRect(rectX, rectY, rectWidth, rectHeight)) {
      rectOver = true;
    }
    else{
      rectOver = false;
    }
  }
  
  public void render(){
    update(mouseX, mouseY);
    int rectFill;
    if (rectOver) {
      rectFill = rectHighlight;
    } 
    else {
      rectFill = rectColor;
    }
    fill(rectFill);
    strokeWeight(0);
    rect(rectX, rectY, rectWidth, rectHeight,8);
    
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(textSize);
    text(Text, rectX+(rectWidth/2), rectY+(rectHeight/2));
    
  }

}

  
  
  
  
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
  
  public void render(){
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
class Slider{
  int rectX;
  int rectY;
  int rectWidth;
  int rectHeight;
  Boolean rectOver;
  int rectFill;
  int rectColor = 200;
  int rectHighlight = 220;
  String Text;
  float level = 10;
  int space = 1;
  
  Slider(int x, int y, int Width, int Height){
    rectX = x;
    rectY = y;
    rectWidth = Width;
    rectHeight = Height;
  }
  
  public void update(int x, int y) {
    if (overRect(rectX, rectY, rectWidth, rectHeight)) {
      rectOver = true;
    }
    else{
      rectOver = false;
    }
  }
  
  public void render(){
    update(mouseX, mouseY);
    int rectFill;
    if (rectOver) {
      rectFill = rectHighlight;
    } 
    else {
      rectFill = rectColor;
    }
    fill(rectFill);
    strokeWeight(0);
    rect(rectX, rectY, rectWidth, rectHeight,4);
    
    for (float i = 1;  i <= level; i++){
      fill(255,0,0,(i/10)*255);
      strokeWeight(0);
      rect((rectX+((rectWidth/10)*i))-((rectWidth-space*9)/10)+(space*i-1)/2, rectY, (rectWidth-space*18)/10, rectHeight, 4);
    }
    
    
  }
  
  public boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  public void changePower(int mousex){
    level = (mousex - (rectX-2)) / (rectWidth/10);
    if (level < 1){
      level = 1;
    }
  }
  
  public String getPower(){
    float percentPower = (level/10)*100;
    return "Power:" + str(PApplet.parseInt(percentPower))+"%";
  }


}
class Timer{
  int time_entered;
  int start_time;
  int elapsed_time;
  float per_done;
  int time_remaining;
  Boolean paused = false;
  int pause_time;
  int unpause_time;
  int time_paused = 0;
  Boolean timerOn = false;
  Boolean timerEnded = false;
  
  Timer(int timeEntered, int startTime, Boolean on){
    time_entered = timeEntered;
    start_time = startTime;
    timerOn = on;
  }
  
  public int timeRemaining(){
    if (!paused){
      int curr_s = second();
      int curr_m = minute();
      int curr_time = curr_m*60 + curr_s;
      elapsed_time = curr_time - (start_time + time_paused);
      time_remaining = time_entered - elapsed_time;
      if (time_remaining == 0){
        timerEnd();
      }
      return time_remaining;
    } else return time_remaining;
  
  }
  
  public float percentDone(){
    per_done = PApplet.parseFloat(elapsed_time) / PApplet.parseFloat(time_entered);
    return per_done;
  }
  
  public void pause(){
    paused = true;
    int curr_s = second();
    int curr_m = minute();
    int curr_time = curr_m*60 + curr_s;
    pause_time = curr_time;
  }
  
  public void unpause(){
    int curr_s = second();
    int curr_m = minute();
    int curr_time = curr_m*60 + curr_s;
    unpause_time = curr_time;
    time_paused = time_paused + (unpause_time - pause_time);
    paused = false;
  }
  
  public void timerEnd(){
    paused = true;
    timerEnded = true;
  }
  
  
  
  
}
  public void settings() {  size(640,640); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Microwave" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
