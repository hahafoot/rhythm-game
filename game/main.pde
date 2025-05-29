//keybinds setter
//keybinds getter
color leftColor = color(255, 255, 0);
color upColor = color(255, 0, 0);
color downColor = color(0, 0, 255);
color rightColor = color(0, 255, 0);
ArrayList<PVector> gurt = new ArrayList<PVector>();
ArrayList<Note> realBeats = new ArrayList<Note>();
int leftLane, rightLane, upLane, downLane;

char lkey, ukey, dkey, rkey;
int gameStartFrame;

int mode = 2; // set to 1 for final build

boolean[] cKeys;


void setup() {
  frameRate(120 ); //getbpm
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

  for (PVector p : gurt) {
    if (frameCount / 60 == p.y) realBeats.add(new Note(p));
  }
  for (Note n : realBeats) {
    n.drawNote();
  }
}



void draw() {
  switch (mode) {
  case 1:
    //start menu
    break;
  case 2:
    clear();
    fill(0);
    rect(100, 100, 100, 100);
    fill(255);
    textSize(50);
    //text(frameCount, 100, 100, 100);
    text(frameCount / 60, 100, 200, 200);
    drawBeats();

    if (cKeys[LEFT] || cKeys[lkey]) leftColor = 255;
    else leftColor = color(255, 255, 0);
    if (cKeys[UP] || cKeys[ukey]) upColor = 255;
    else upColor = color(255, 0, 0);
    if (cKeys[DOWN] || cKeys[dkey]) downColor = 255;
    else downColor = color(0, 0, 255);
    if (cKeys[RIGHT] || cKeys[rkey]) rightColor = 255;
    else rightColor = color(0, 255, 0);

    fill(leftColor);
    rect(width * 4/11, height * 7/8, 40, 40);
    fill(downColor);
    rect(width * 5/11, height * 7/8, 40, 40);
    fill(upColor);
    rect(width * 6/11, height * 7/8, 40, 40);
    fill(rightColor);
    rect(width * 7/11, height * 7/8, 40, 40);


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
