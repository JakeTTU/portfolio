class Button{
  int rectX, rectY;      // Position of square button
  int rectWidth, rectHeight;     // Diameter of rect
  boolean rectOver = false;
  color rectColor = color(50);
  color rectHighlight = color(100);
  color currentColor, baseColor;
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
  
  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
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
    rect(rectX, rectY, rectWidth, rectHeight,8);
    
    fill(255);
    textAlign(CENTER,CENTER);
    textSize(textSize);
    text(Text, rectX+(rectWidth/2), rectY+(rectHeight/2));
    
  }

}

  
  
  
  
