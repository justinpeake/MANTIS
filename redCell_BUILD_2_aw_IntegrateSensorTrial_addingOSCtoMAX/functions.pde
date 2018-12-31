void heartBeatData() {
  if (heart > 240) {
    tminterval = millis() - tmprevious;
    tmprevious = millis();
  }

  if (tminterval > 250) {
    tamer = true;
  } else { 
    tamer = false;
  }
  if (heart > 240 && tamer) {
    counter ++;       // CHANGE TO CELLNUM
    interval = millis() - previous;
    previous = millis();

    bpm = (60/interval*1000);
    aoc =  abs(bpm - prebpm);
    prebpm = bpm;

    // if it's a beat then do it
    messageToMax = int(random(15));
    sendOSC();
    println(counter, ",", interval, ",", bpm, ",", aoc, ",", breathVol);
  }
}


void cellCheck () {

  if (heart > 230 && tamer) {
    // PUT CELL DRAW HERE
    placementValues();

  flasher = random(15);

  cells[cellNum] = new Cell(x, y, cW, cH, flasher, 0, 0);

  // don't forget to add one to cellNum for every mouse click

  cellNum++;
  }
}
