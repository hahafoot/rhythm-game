//keybinds setter
//keybinds getter
color defaultleftColor = color(255, 255, 0);
color defaultupColor = color(255, 0, 0);
color defaultdownColor = color(0, 0, 255);
color defaultrightColor = color(0, 255, 0);
color leftColor = defaultleftColor;
color upColor = defaultupColor;
color downColor = defaultdownColor;
color rightColor = defaultrightColor;
ArrayList<PVector> gurt = new ArrayList<PVector>();
ArrayList<Note> realBeats = new ArrayList<Note>();
int leftLane, rightLane, upLane, downLane;

char lkey, ukey, dkey, rkey;
int gameStartFrame;
int bpm = 120; //getbpm

int mode = 2; // set to 1 for final build

boolean[] cKeys;


void setup() {
  frameRate(60);
  fullScreen();
  background(0);
  cKeys = new boolean[255];
  lkey = 'd';
  dkey = 'f';
  ukey = 'j';
  rkey = 'k';
  leftLane = width * 4/11;
  downLane = width * 5/11;
  upLane = width * 6/11;
  rightLane = width * 7/11;
  //temp vals
  gurt.add(new PVector(1, 1, 0));
  gurt.add(new PVector(2, 1, 0));
  gurt.add(new PVector(3, 1, 0));
  gurt.add(new PVector(4, 1, 0));
  gurt.add(new PVector(1, 2, 1));
  gurt.add(new PVector(1, 4, 0));
  gurt.add(new PVector(3, 2, 0));
  gameStartFrame = 0;
}

void drawBeats() {
  color noteColor = 0;
  

  for (PVector p : gurt) {
    switch ((int)p.x) {
      case 1: 
        noteColor = defaultleftColor;
        break;
      case 2:
        noteColor = defaultdownColor;
        break;
      case 3:
        noteColor = defaultupColor;
        break;
      case 4:
        noteColor = defaultrightColor;
        break;
    }
    if (frameCount / 60.0 == p.y + 0.0 && frameCount % 60 == 0) {
      realBeats.add(new Note(p, noteColor));
    }
  }
  for (Note n : realBeats) {
    n.drawNote(bpm); // getbpm
  }
}



void draw() {

  switch (mode) {
  case 1:
    //start menu
    break;
  case 2:
    background(0);
    fill(0);
    rect(0, 0, 200, 200);
    fill(255);
    textSize(50);
    text(realBeats.size(), 100, 100, 100);
    text(frameCount / 60, 100, 200, 200);
    drawBeats();

    if (cKeys[LEFT] || cKeys[lkey]) leftColor = 255;
    else leftColor = defaultleftColor;
    if (cKeys[UP] || cKeys[ukey]) upColor = 255;
    else upColor = defaultupColor;
    if (cKeys[DOWN] || cKeys[dkey]) downColor = 255;
    else downColor = defaultdownColor;
    if (cKeys[RIGHT] || cKeys[rkey]) rightColor = 255;
    else rightColor = defaultrightColor;

    fill(leftColor);
    rect(width * 4/11, height * 7/8, 40, 40);
    fill(downColor);
    rect(width * 5/11, height * 7/8, 40, 40);
    fill(upColor);
    rect(width * 6/11, height * 7/8, 40, 40);
    fill(rightColor);
    rect(width * 7/11, height * 7.0/8, 40, 40);
    

    break;
  }
}

public void keyPressed() {
  if (key == CODED && keyCode < 255) {
    cKeys[keyCode] = true;
  }
  if (key == lkey) {
    cKeys[lkey] = true;
  }
  if (key == dkey) {
    cKeys[dkey] = true;
  }
  if (key == ukey) {
    cKeys[ukey] = true;
  }
  if (key == rkey) {
    cKeys[rkey] = true;
  }
}

public void keyReleased() {
  if (key == CODED && keyCode < 255) {
    cKeys[keyCode] = false;
  }
  if (key == lkey) {
    cKeys[lkey] = false;
  }
  if (key == dkey) {
    cKeys[dkey] = false;
  }
  if (key == ukey) {
    cKeys[ukey] = false;
  }
  if (key == rkey) {
    cKeys[rkey] = false;
  }
}
