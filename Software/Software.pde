import processing.serial.*;

Serial myPort;
PFont font;
int num;

float humOut;
float tempOut;
float humIn;
float tempIn;

float tolerence;
float optTemp;
float ctrTemp;

boolean flag;  //For the main algorithm
boolean move;  //For Slider
boolean state; //To store whether the A.C. is On/Off

void setup() {
  size(1000, 500);

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  num = 0;
  font = createFont("BreeSerif.vlw", 24);
  tolerence = 1.5;
  flag = false;
  move = false;
  state = false;
}

void draw() {
  background(51);
  displayInfo();
  vizualizeData();
  readData();
}

void readData() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();
    if (inBuffer != null) {
      String[] data = split(inBuffer, ',');
      for (int i = 0; i < data.length; i++) {
        println("data[" + i + "]: " + data[i]);
      }

      //set global temperature and humidity variables
      humOut = parseFloat(data[0]);
      tempOut = parseFloat(data[1]);
      humIn = parseFloat(data[2]);
      tempIn = parseFloat(data[3]);

      //analyse and display data
      optTemp = (0.078 * tempOut) + 23.25;
      analyseCtrTemp();
      num++;
    }
  }
}

void analyseCtrTemp() { 
  if (flag == false) {
    ctrTemp = optTemp;
    flag = true;
  }
  if (((optTemp - tolerence) <= tempIn) && ((optTemp + tolerence) > tempIn)) {
    flag = false;//Do nothing
  } else {
    if ((optTemp + tolerence) >= tempIn) {
      ctrTemp = constrain(++ctrTemp, 16, 26);
      println("ctrTemp: " +ctrTemp);
      myPort.write(round(ctrTemp));
    } else if ((optTemp - tolerence) < tempIn) {
      ctrTemp = constrain(--ctrTemp, 16, 26);
      println("ctrTemp: " +ctrTemp);
      myPort.write(round(ctrTemp));
    }
  }
}

void vizualizeData() {
  int rectWidth = 50;
  noStroke();
  rectMode(CORNER);
  fill(#FCFCFC);
  rect(width/8 - rectWidth, 0, rectWidth, 5*tempOut);
  fill(#5AD4FF);
  rect(width/8 + rectWidth, 0, rectWidth, 5*humOut);

  fill(#FCFCFC);
  rect(2*width/5 - rectWidth, 0, rectWidth, 5*tempIn);
  fill(#5AD4FF);
  rect(2*width/5 + rectWidth, 0, rectWidth, 5*humIn);

  fill(255);
  textFont(font);
  text("OUTSIDE", width/8 - rectWidth/2, 9*height/10);
  text("INSIDE", 2*width/5 - rectWidth/2, 9*height/10);

  textFont(font);
  textSize(18);
  text(nf(tempOut, 1, 1) + " °C", width/8 - rectWidth/2 - textWidth(nf(tempOut, 1, 1) + " °C")/2, 5*tempOut + 36);
  text(round(humOut) + "%", width/8 + 3*rectWidth/2 - textWidth(round(humOut) + "%")/2, 5*humOut + 36);
  text(nf(tempIn, 1, 1) + " °C", 2*width/5 - rectWidth/2 - textWidth(nf(tempIn, 1, 1) + " °C")/2, 5*tempIn + 36);
  text(round(humIn) + "%", 2*width/5 + 3*rectWidth/2 - textWidth(round(humIn) + "%")/2, 5*humIn + 36);
}

void displayInfo() {
  textFont(font);
  textSize(18);
  text("Operative Temp: " + nf(optTemp, 1, 1) + " °C", 3*width/4, height/4);
  text("A.C. Temp: " + round(ctrTemp) + " °C", 3*width/4, height/4 + 36);
  text("Tolerence: " + tolerence, 3*width/4, height/2 + height/25);
  stroke(255);
  line(3*width/4, 3*height/5, width - width/20, 3*height/5);
  noStroke();
  fill(255);
  rectMode(CENTER);
  rect(map(tolerence, 0, 1.5, 3*width/4, width - width/20), 3*height/5, 10, 30, 5);
}

//void switchButton() {
//  pushStyle();
//  fill(255);
//  noStroke();
//  rectMode(CENTER);
//  rect(34*width/40, height - height/10, 100, 50, 10);
//  fill(0);
//  textSize(18);
//  textAlign(LEFT, CENTER);
//  if (state == false) {
//    text("Turn On", 34*width/40 - textWidth("Turn On")/2, height - height/10 - 3);
//  } else {
//    text("Turn Off", 34*width/40 - textWidth("Turn Off")/2, height - height/10 - 3);
//  }
//  popStyle();
//}

void mouseDragged() {
  if ((dist(mouseX, mouseY, map(tolerence, 0, 1.5, 3*width/4, width - width/20), 3*height/5) < 20) || move == true) {
    move = true;
    tolerence = map(mouseX, 3*width/4, width - width/20, 0, 1.5);
    tolerence = constrain(tolerence, 0, 1.5);
    tolerence = parseFloat(nf(tolerence, 1, 2));
  } else {
    move = false;
  }
}

//void mouseClicked() {
//  if ((mouseX < (34*width/40 + 50)) && (mouseX > (34*width/40 - 50)) && (mouseY < (9*height/10 + 25)) && (mouseY > (9*height/10 - 25))) {
//    if (state == false) {
//      myPort1.write(1);
//    } else {
//      myPort1.write(0);
//    }
//    state = !state;
//  }
//}
