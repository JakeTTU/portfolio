class Slider{
  int rectX;
  int rectY;
  int rectWidth;
  int rectHeight;
  Boolean rectOver;
  color rectFill;
  color rectColor = 200;
  color rectHighlight = 220;
  String Text;
  float level = 10;
  int space = 1;
  
  Slider(int x, int y, int Width, int Height){
    rectX = x;
    rectY = y;
    rectWidth = Width;
    rectHeight = Height;
  }
  
  void update(int x, int y) {
    if (overRect(rectX, rectY, rectWidth, rectHeight)) {
      rectOver = true;
    }
    else{
      rectOver = false;
    }
  }
  
  void render(){
    update(mouseX, mouseY);
    color rectFill;
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
  
  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }
  
  void changePower(int mousex){
    level = (mousex - (rectX-2)) / (rectWidth/10);
    if (level < 1){
      level = 1;
    }
  }
  
  String getPower(){
    float percentPower = (level/10)*100;
    return "Power:" + str(int(percentPower))+"%";
  }


}
