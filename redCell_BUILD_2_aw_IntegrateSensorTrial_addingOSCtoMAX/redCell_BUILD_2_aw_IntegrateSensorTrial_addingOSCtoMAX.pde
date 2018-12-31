import netP5.*;
import oscP5.*;

import processing.serial.*;

OscP5 oscP5;
NetAddress oscDestination;

OscMessage myMessage;

Serial myPort;

float breath = 0;     
float heart = 0; 
float breathVol;
float previous=0;  // timer
float current=0;  // timer
float counter = 0;  // number of heart beats total
float interval=0; // interval in ms between heart beats
float bpm=0; // heart rate in bpm
float aoc=0;  // amount of change in bpm / per beat
float prebpm=0; // previous bpm
float tminterval;
float tmprevious;
boolean tamer;


int sizeW = 1280; // window size
int sizeH = 780;

int cW = 0; // initialize cell size
int cH = 0;

int x = 0; //initialize cell pos variables
int y = 0;

float flasher = 15; // the speed at which cell will flash

int nPR = 50;  // Number of cells Per Row

int nP = nPR * nPR;  // total number of cells [calculated in Setup()]

// It isn't a good idea to have a global "i" value
// and later use it as a variable in for loops
// call it something like cellNum instead

int cellNum = 0; // index

int messageToMax = 1;

Cell[] cells = new Cell[nP];  // initialize size of object array

void setup () {

  //println (nP);

  size(1280, 720);

  background(0);

  noStroke(); //avoids gaps in cells
  
  myPort = new Serial(this, Serial.list()[3], 115200);
  myPort.bufferUntil('\n');

  cW = sizeW / nPR; // auto scale cell size to window size
  cH = sizeH / nPR;

  for (int i = 0; i < cells.length; i++) {
    cells[i] = new Cell(x, y, cW, cH, flasher, 0, 0);
  }
  
  // osc stuff added Dec31,18
    oscP5 = new OscP5(this, 7400);
  oscDestination = new NetAddress("127.0.0.1", 7400);
  oscP5.plug(this, "a", "/a");
  oscP5.plug(this, "b", "/b"); 
}

void draw () {
  
  heartBeatData();
  cellCheck();
 
  //messageToMax = int(random(15));
  
  // add a for loop here to display every cell

  for (int i = 0; i < cells.length; i++) {
    cells[i].display();
  }
  
  //sendOSC();
}

void mousePressed () {  // make this what gets called when a heart beat thumps

  placementValues();

  flasher = interval / frameRate;
  

  cells[cellNum] = new Cell(x, y, cW, cH, flasher, 0,0);

  // don't forget to add one to cellNum for every mouse click

  cellNum++;
  
}


class Cell {
  int xx, yy, w, h;
  float fS;
  float rVal, bVal;

  Cell (int xPos, int yPos, int cellW, int cellH, float flash, float red, int blue) {
    xx = xPos;
    yy = yPos;
    w = cellW;
    h = cellH;
    fS = flash;
    rVal = red;
    bVal = blue;
  }

  void display () {

    fill(rVal, 0, bVal);

    // ramps p3ixel color value up and down

    rVal = rVal + fS;
    if (rVal >= 255 || rVal <= 0) {
      fS *= -1;  // reverse direction
    }

    rect(xx, yy, w, h);  //create the cell
  }
}


void placementValues () {  // THIS keeps grid of cells wrapping inside the bounds of the window

  x = x + cW;

  if (x > (sizeW-cW/2) && y >= sizeH - cH/2) {  // back to the top (needs to go before)
    y = 0;
    x = 0;
  }

  if (x > (sizeW-cW/2) ) {  // wrap cells to new line
    y = y + cH;
    x = 0;
  }

  // replace the global "i" to cellNum

  if (cellNum >= nP-1) {  // reset index 'cellNum' to 0 to avoid ArrayOutOfBoundsException
    cellNum = 0;
  } else {
    cellNum++;
  }
}

void serialEvent(Serial myPort) { 

  String inString = myPort.readStringUntil('\n'); 
  if (inString != null) {
    inString = trim(inString); 
    float[] colors = float(split(inString, ",")); 

    if (colors.length >=2) {
      heart = map(colors[0], 0, 1023, 0, 300);
      breath = abs(map(colors[1], 220, 600, 0, 300));
      
    }
  }
}

void sendOSC() {
  OscMessage myMessage = new OscMessage ("/beat");
  
  myMessage.add(messageToMax);
  
  oscP5.send(myMessage, oscDestination);
 
}
