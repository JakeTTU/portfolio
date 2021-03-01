import processing.sound.*;
float start2 = PI*1.5;
float end2;

float end = PI*1.5;
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


void setup(){
  size(640,640);
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

void draw(){
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

void promptCloseDoor(){
  doorPrompt = true;
  display();
}

void mousePressed() {
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

void mouseDragged(){
  if (power.rectOver && !timerOn){
    power.changePower(mouseX);
    changePower = true;
  }
  else changePower = false;
}

void stopFunc(){
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

void startTimer(int timeEntered, int startTime){
  if (!timerOn){
    timer = new Timer(timeEntered, startTime, true);
    timerOn = true;
    cooking = true;
    playCookSound();
  }
  
}

void startTime(){
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

void circleFunction(){
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
      arc(width/2, height/4, 150, 150, PI*1.5, PI*3.5);
    }
    else if (flashCount == 3){
      strokeWeight(15);
      stroke(24, 211, 64);
      noFill();
      arc(width/2, height/4, 150, 150, PI*1.5, PI*3.5);
    }
  }
}

String formatTimeRamaining(){
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

String timerDone(){ 
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

void display(){
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

void playCookSound(){
  if(!startCook.isPlaying()){
    startCook.play();
  }
}

void stopCookSound(){
  if(startCook.isPlaying()){
    startCook.stop();
  }
}

void doorFunc(){
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

void clearWithDoor(){
  for (int i = 0; i < disp.length; i++){
      disp[i] = ' ';
      timerOn = false;
      timer.timerEnded = false;
      timeInputs = 0;
      flashCount = 0;
      cookDone = false;
    }

}
