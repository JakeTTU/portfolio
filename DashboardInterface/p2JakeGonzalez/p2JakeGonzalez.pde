Button turnRight;
Button turnLeft;
Button accelerator;
Button brake;
Button hazardLights;
Button park;
Button reverse;
Button neutral;
Button drive;
Button warningLights;

PImage engineTemp;
PImage tirePressure;
PImage oilPressure;
PImage fuel;
PImage checkEngine;
PImage traction;
PImage seatbelt;
PImage airbag;
PImage battery;
PImage rightArrow;
PImage leftArrow;
PImage washer;



int backgroundColor = 248;
int controlsX = 1000-130;
int controlsY = 500/2-(375/2);
int controlsWidth = 120;
int controlsHeight = 390;
int controlsSpacing = 5;
int adjY = 25;
int adjX = -80;

boolean accelerateToggle = false;
boolean brakeToggle = false;
boolean warningLightsToggle = false;
boolean rightSignalToggle = false;
boolean leftSignalToggle = false;
boolean hazardLightsToggle = false;


int startAcc;
int startRev;
int startBrake;
int outsideTemp = 90;

float speed = 0;
float topSpeed = 200;
float topSpeedRev = 20;
float percSpeed;
float fuelLevel = 1;
float distanceTraveled = 0;
float maxDistance = 4;
float distanceRemaining = maxDistance;
float percTemp;
float maxTemp = 220 - 90;
float temp = outsideTemp;
float prevTemp;

float end = PI*.75;
float start = end;

float startFuel = PI*2.4;
float endFuel = startFuel;

float endTemp = PI*.6;
float startTemp = endTemp;


String selectedGear = "P";

String[] gears;
 

void setup(){
  size(1000,500);
  turnLeft = new Button(controlsX+5, controlsY+5, 52+(1/2), 50, "Turn\nLeft", 12);
  turnRight = new Button(controlsX+10 +52+(1/2), controlsY+5, 52+(1/2), 50, "Turn\nRight", 12);
  accelerator = new Button(controlsX+5, controlsY+60, 110, 50, "Accelerator", 12);
  brake = new Button(controlsX+5, controlsY+115, 110, 50, "Brake", 12);
  hazardLights = new Button(controlsX+5, controlsY+170, 110, 50, "Hazard Lights", 12);
  park = new Button(controlsX+5, controlsY+225, 52+(1/2), 50, "P", 16);
  reverse = new Button(controlsX+10 +52+(1/2), controlsY+225, 52+(1/2), 50, "R", 16);
  neutral = new Button(controlsX+5, controlsY+280, 52+(1/2), 50, "N", 16);
  drive = new Button(controlsX+10 +52+(1/2), controlsY+280, 52+(1/2), 50, "D", 16);
  warningLights = new Button(controlsX+5, controlsY+335, 110, 50, "Warning Lights", 12);
  engineTemp = loadImage("icons/engineTemp.png");
  tirePressure = loadImage("icons/tirePressure.png");
  oilPressure = loadImage("icons/oilPressure.png");
  fuel = loadImage("icons/fuel.png");
  checkEngine = loadImage("icons/checkEngine.png");
  traction = loadImage("icons/traction.png");
  seatbelt = loadImage("icons/seatbelt.png");
  airbag = loadImage("icons/airbag.png");
  battery = loadImage("icons/battery.png");
  rightArrow = loadImage("icons/rightArrow.png");
  leftArrow = loadImage("icons/leftArrow.png");
  washer = loadImage("icons/washer.png");
  gears = new String[4];
  gears[0] = "P";
  gears[1] = "R";
  gears[2] = "N";
  gears[3] = "D";
}


void draw(){
  background(backgroundColor);
  //image(photo, (1000/2)-(250/2), 500/4-(250/2));
  stroke(0);
  strokeWeight(1);
  fill(255);
  rect(controlsX,controlsY,controlsWidth,controlsHeight,8);
  speedometerBackground();
  turnRight.render();
  turnLeft.render();
  accelerator.render();
  brake.render();
  hazardLights.render();
  park.render();
  reverse.render();
  neutral.render();
  drive.render();
  warningLights.render();
  if (accelerateToggle){
    if (selectedGear == "D"){
      accelerate();
    }
    if (selectedGear == "R"){
      rev();
    }
  }
  if (brakeToggle){
    brake();
  }
  if (warningLightsToggle){
    displayWarningLights();
  }
  if (rightSignalToggle){
    int flash = millis();
    if ((flash / 800) % 2  == 0){
      displayRightSignal();
    }
    //displayRightSignal();
    
  }
  if (leftSignalToggle){
    int flash = millis();
    if ((flash / 800) % 2  == 0){
      displayLeftSignal();
    }
    //displayLeftSignal();
    
  }
  
  //lineAngle(100, 100, (360*(percSpeed/100)), 50);
  //lineAngle2(100, 100, (360*(percSpeed/100)), 50);
  speedometer();
  tachometer();
  tachBackground();
  displayTemps();
  displayGear();
  engineTempBackground();
  engineTempGuage();
  fuelGaugeBackground();
  fuelGuage();
}

void mousePressed() {
  //if (turnRight.rectOver){
  //  backgroundColor = 123;
  //}
  //if (turnLeft.rectOver){
  //  backgroundColor = 248;
  //}
  if (accelerator.rectOver){
    if (selectedGear == "D"){
      if(fuelLevel > 0){
        accelerateStart();
      }
    }
    if (selectedGear == "R"){
      if(fuelLevel > 0){
        reverseStart();
      }
    }
  }
  if (brake.rectOver){
    brakeStart();
  }
  if (park.rectOver){
    selectedGear = "P";
  }
  if (reverse.rectOver){
    selectedGear = "R";
  }
  if (neutral.rectOver){
    selectedGear = "N";
  }
  if (drive.rectOver){
    selectedGear = "D";
  }
  if (warningLights.rectOver){
    if (!warningLightsToggle){
      warningLightsToggle = true;
    }
    else if (warningLightsToggle){
      warningLightsToggle = false;
    }
  }
  if (turnLeft.rectOver){
    if (!hazardLightsToggle){
      if(!leftSignalToggle){
        leftSignalToggle = true;
        rightSignalToggle = false;
      }
      else if (leftSignalToggle){
        leftSignalToggle = false;
      }
    }
  }
  if (turnRight.rectOver){
    if (!hazardLightsToggle){
      if(!rightSignalToggle){
        rightSignalToggle = true;
        leftSignalToggle = false;
      }
      else if (rightSignalToggle){
        rightSignalToggle = false;
      }
    }
  }
  if (hazardLights.rectOver){
    if (!hazardLightsToggle){
      hazardLightsToggle = true;
      leftSignalToggle = true;
      rightSignalToggle = true;
    }
    else if (hazardLightsToggle){
      hazardLightsToggle = false;
      leftSignalToggle = false;
      rightSignalToggle = false;
    }
  }
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      backgroundColor = 255;
      accelerateStart();
    } else if (keyCode == DOWN) {
      backgroundColor = 0;
      accelerateToggle = false;
    } 
  } else {
    backgroundColor = backgroundColor;
  }
}

//void keyReleased() {
//  backgroundColor = 248;
//}

void accelerateStart(){
  startAcc = millis();
  accelerateToggle = true;
  brakeToggle = false;
}

void reverseStart(){
  startRev = millis();
  accelerateToggle = true;
  brakeToggle = false;
}

void accelerate(){
  int curr = millis();
  int diff = curr - startAcc;
  speedup(diff/10);  
}

void rev(){
  int curr = millis();
  int diff = curr - startRev;
  speedupRev(diff/10);  
}

void speedupRev(int time){
  if (speed < topSpeedRev-1){
    speed = (time/10)+(speed/5);
  }
}

void speedup(int time){
  if (speed < topSpeed-1){
    speed = (time/10)+(speed/5);
  }
  useFuel(speed, time);
  if (fuelLevel <= 0){
    brakeStart();
  }
}

void brakeStart(){
  startBrake = millis();
  brakeToggle = true;
  accelerateToggle = false;
}

void brake(){
  int curr = millis();
  int diff = curr - startBrake;
  slowdown(diff/10);  
}

void slowdown(int time){
  if (speed > 0){
    speed = (speed) - (1+(time/200));
  }
  if (speed <= 0){
    brakeToggle = false;
    speed = 0;
  }
}

//void lineAngle(int x, int y, float angle, float length)
//{
//  strokeWeight(5);
//  line(x-cos(angle)*(length/2), y-sin(angle)*(length/2), x-cos(angle)*length, y-sin(angle)*length);
//  strokeWeight(1);
//}

//void lineAngle2(int x, int y, float angle, float length)
//{
//  line(x, y, x-cos(angle)*length, y-sin(angle)*length);
//}

void speedometer(){
  int x = 1000/2+adjX;
  int y = 500/2+adjY;
  float per_speed = speed/topSpeed;
  prevTemp = temp;
  temp = (maxTemp) * per_speed + 90;
  if (temp > prevTemp){
    temp = (maxTemp) * per_speed + 90;
  }
  else{
    temp = prevTemp;
  }
  float a = PI*1.75;
  float b = PI*1.5;
  start = end+((PI*1.5)*(per_speed));
  strokeWeight(15);
  stroke(240, 50, 36);
  noFill();
  arc(x, y, 325, 325, end, start);
  line(x-cos(a+(b*(per_speed)))*150, y-sin(a+(b*(per_speed)))*150, x-cos(a+(b*(per_speed)))*175, y-sin(a+(b*(per_speed)))*175);
}

void speedometerBackground(){
  int x = 1000/2+adjX;
  int y = 500/2+adjY;
  strokeWeight(2);
  stroke(0);
  noFill();
  arc(x, y, 350, 350, PI*.75, PI*2.25);
  arc(x, y, 300, 300, PI*.75, PI*2.25);
  int intervals = 40;
  float a = PI*1.75;
  float b = PI*1.5;
  
  for (float i = 0;  i <= intervals; i++){
    if (i % 2 == 0){
      line(x-cos(a+(b*(i/40)))*150, y-sin(a+(b*(i/40)))*150, x-cos(a+(b*(i/40)))*200, y-sin(a+(b*(i/40)))*200);
      textSize(16);
      fill(0);
      if (i == 0){
        text("0\nMPH", x-cos(a+(b*(i/40)))*220, y-sin(a+(b*(i/40)))*220);
      }
      else{
        text(str(round((i/40)*200)), x-cos(a+(b*(i/40)))*220, y-sin(a+(b*(i/40)))*220);
      }
      
    }
    else{
      line(x-cos(a+(b*(i/40)))*150, y-sin(a+(b*(i/40)))*150, x-cos(a+(b*(i/40)))*190, y-sin(a+(b*(i/40)))*190);
    }
  }
  textSize(50);
  fill(0);
  text(str(round(speed)), x, y);
}

void tachometer(){
  int rectWidth = 200;
  int rectHeight = 25;
  int x = 1000/2 - rectWidth/2 + adjX;
  int y = 500/2 - rectHeight/2 - 50 + adjY;
  float a = PI*1.75;
  float b = PI*1.5;
  float per_gear = (speed % 40)/40;
  float gear = speed/40 + 1;
  

  int space = 1;
  
  if (per_gear > .95){
    delay(10);
  }
  stroke(0);
  strokeWeight(1);
  rect(x, y, rectWidth, rectHeight,4);
  for (float i = 0;  i <= per_gear*9; i++){
    if (i > 0){
      fill((i/9)*255,255-(255*(i/8)),0,(i/8)*255);
      strokeWeight(0);
      rect((x+((rectWidth/8)*i))-((rectWidth-space*8)/8)+((space*i-1)/2), y, (rectWidth-(space*18))/8, rectHeight, 4);
    }
  }
}

void tachBackground(){
  int rectWidth = 200;
  int rectHeight = 25;
  int x = 1000/2 - rectWidth/2 +adjX;
  int y = 500/2 - rectHeight/2 - 50 +adjY;
  int space = 1;
  for (float i = 1; i <= 8; i++){
    stroke(0);
    strokeWeight(1);
    line(((x+((rectWidth/8)*i))-((rectWidth-space*8)/8)+((space*i-1)/2)+rectWidth/16), y, (x+((rectWidth/8)*i)-((rectWidth-space*8)/8)+((space*i-1)/2)+rectWidth/16),y-5);
    textSize(14);
    fill(0);
    text(str(round(i)), ((x+((rectWidth/8)*i))-((rectWidth-space*8)/8)+((space*i-1)/2)+rectWidth/16), y-16);
  }
  textSize(12);
  fill(0);
  textAlign(CENTER,CENTER);
  text("RPM x1000", 1000/2+adjX, 500/2-95+adjY);
}

void displayTemps(){
  textSize(14);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Outside: "+str(outsideTemp)+"°", 1000/2+adjX, 500/2+100+adjY+15);
  text("Inside: 68°", 1000/2+adjX, 500/2+120+adjY+15);
}

void displayGear(){
  color selectedColor = color(20, 225, 17);
  textSize(22);
  textAlign(CENTER,CENTER);
  
  for (int i = 0; i < 4; i++){
    int num = i+1;
    if (num == 1){
      if (selectedGear == gears[i]){
        fill(selectedColor);
        text(gears[i], 1000/2+adjX-45, 500/2+65+adjY);
      }
      else{
        fill(0);
        text(gears[i], 1000/2+adjX-45, 500/2+65+adjY);
      }
    }
    else if (num == 2){
      if (selectedGear == gears[i]){
        fill(selectedColor);
        text(gears[i], 1000/2+adjX-15, 500/2+65+adjY);
      }
      else{
        fill(0);
        text(gears[i], 1000/2+adjX-15, 500/2+65+adjY);
      }
    }
    else if (num == 3){
      if (selectedGear == gears[i]){
        fill(selectedColor);
        text(gears[i], 1000/2+adjX+15, 500/2+65+adjY);
      }
      else{
        fill(0);
        text(gears[i], 1000/2+adjX+15, 500/2+65+adjY);
      }
    }
    else if (num == 4){
      if (selectedGear == gears[i]){
        fill(selectedColor);
        text(gears[i], 1000/2+adjX+45, 500/2+65+adjY);
      }
      else{
        fill(0);
        text(gears[i], 1000/2+adjX+45, 500/2+65+adjY);
      }
    }
  }
}

void displayWarningLights(){
  int x1 = 45;
  int x1_2 = x1 - 30;
  int x2 = 650;
  int x2_2 = x2 - 30;
  int y1 = 340;
  int y2 = 400;
  int space  = 60;
  int imgWidth = 75;
  int imgHeight = 75;
  image(engineTemp, x1,y1, imgWidth, imgHeight);
  image(tirePressure,x1+space,y1, imgWidth, imgHeight);
  image(oilPressure,x1_2,y2, imgWidth, imgHeight);
  image(fuel,x1_2+space,y2, imgWidth, imgHeight);
  image(checkEngine,x1_2+(space*2),y2, imgWidth, imgHeight);
  image(traction,x2,y1, imgWidth, imgHeight);
  image(seatbelt,x2+space,y1, imgWidth, imgHeight);
  image(airbag,x2_2,y2, imgWidth, imgHeight);
  image(battery,x2_2+space,y2, imgWidth, imgHeight);
  image(washer,x2_2+(space*2),y2, imgWidth, imgHeight);
}

void displayRightSignal(){
  image(rightArrow, 1000/2 + adjX + 300, 250+adjY, 60, 60);
  
}
void displayLeftSignal(){
  image(leftArrow, 1000/2 + adjX - 360, 250+adjY, 60, 60);
}

void engineTempBackground(){
  int x = 1000/4+adjX;
  int y = 500/4+adjY;
  strokeWeight(2);
  stroke(0);
  noFill();
  arc(x, y, 175, 175, PI*.6, PI*1.75);
  arc(x, y, 150, 150, PI*.6, PI*1.75);
  //int intervals = 40;
  float a = PI*1.6;
  float b = PI*1.16;
  for (float i=0; i<5; i++){
    line(x-cos(a+(b*(i/4)))*75, y-sin(a+(b*(i/4)))*75, x-cos(a+(b*(i/4)))*100, y-sin(a+(b*(i/4)))*100);
    if (i % 2 == 0){
      textSize(12);
      fill(0);
      text(str(round((i*40 + 100)))+"°", x-cos(a+(b*(i/4)))*120, y-sin(a+(b*(i/4)))*120);
    }
  }
  textSize(14);
  fill(0);
  //String sTemp = nf(temp, 0, 0);
  text("Engine\n"+round(temp)+"°", x-10, y-10);
 
}

void fuelGaugeBackground(){
  int x = 750+adjX;
  int y = 125+adjY;
  strokeWeight(2);
  stroke(0);
  noFill();
  arc(x, y, 175, 175, PI*1.25, PI*2.4);
  arc(x, y, 150, 150, PI*1.25, PI*2.4);
  //int intervals = 40;
  float a = PI*2.25;
  float b = PI*1.15;
  for (float i=0; i<5; i++){
    line(x-cos(a+(b*(i/4)))*75, y-sin(a+(b*(i/4)))*75, x-cos(a+(b*(i/4)))*100, y-sin(a+(b*(i/4)))*100);
    if (i == 0){
      textSize(12);
      fill(0);
      text("Full", x-cos(a+(b*(i/4)))*120, y-sin(a+(b*(i/4)))*120);
    } 
    else if (i == 2){
      textSize(12);
      fill(0);
      text("Half", x-cos(a+(b*(i/4)))*120, y-sin(a+(b*(i/4)))*120);
    } 
    else if (i == 4){
      textSize(12);
      fill(0);
      text("Empty", x-cos(a+(b*(i/4)))*120, y-sin(a+(b*(i/4)))*120);
    } 
  }
 
  if(distanceRemaining >= 0){
    textSize(14);
    fill(0);
    String sDist = nf(distanceRemaining, 0, 2);
    text(sDist+" Miles\nRemaining", x+10, y-10);
  }
  else{
    textSize(14);
    fill(0);
    text("0 Miles\nRemaining", x+10, y-10);
  }
 
}

void fuelGuage(){
  int x = 750+adjX;
  int y = 125+adjY;
  float a = PI*2.25;
  float b = PI*1.15;
  //float b = PI*1.15;
  endFuel = startFuel-((PI*1.15)*(fuelLevel));
  strokeWeight(10);
  stroke(240, 50, 36);
  noFill();
  arc(x, y, 162.5, 162.5, endFuel, startFuel);
  line(x-cos(a+(b*(1-fuelLevel)))*75, y-sin(a+(b*(1-fuelLevel)))*75, x-cos(a+(b*(1-fuelLevel)))*90, y-sin(a+(b*(1-fuelLevel)))*90);
  
}

void useFuel(float speed, int time){
  float time2 = time;
  distanceTraveled = (speed*(time2/360000));
  fuelLevel = 1 - distanceTraveled/maxDistance;
  calcDistanceRemaining();
}

void calcDistanceRemaining(){
  distanceRemaining = maxDistance - distanceTraveled;
}

void engineTempGuage(){
  if (temp>100){
    percTemp = (temp-100)/160;
  }
  //percTemp = temp/260;
  int x = 1000/4+adjX;
  int y = 500/4+adjY;
  float a = PI*1.6;
  float b = PI*1.16;
  //float b = PI*1.15;
  startTemp = endTemp+((PI*1.15)*(percTemp));
  strokeWeight(10);
  stroke(240, 50, 36);
  noFill();
  arc(x, y, 162.5, 162.5, endTemp, startTemp);
  line(x-cos(a+(b*(percTemp)))*75, y-sin(a+(b*(percTemp)))*75, x-cos(a+(b*(percTemp)))*90, y-sin(a+(b*(percTemp)))*90);
  
}
