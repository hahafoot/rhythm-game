//keybinds setter
//keybinds getter
color leftColor = color(255, 255, 0);
color upColor = color(255, 0, 0);
color downColor = color(0, 0, 255);
color rightColor = color(0, 255, 0);

char lkey,ukey,dkey,rkey;


boolean[] cKeys;


void setup() {
  fullScreen();
  background(0);
  cKeys = new boolean[255];
  lkey = 'a';
}

void draw() {
  if (cKeys[LEFT]) leftColor = 255;
  else leftColor = color(255,255,0);
  if (cKeys[UP]) upColor = 255;
  else upColor = color(255,0,0);
  if (cKeys[DOWN]) downColor = 255;
  else downColor = color(0,0,255);
  if (cKeys[RIGHT]) rightColor = 255;
  else rightColor = color(0,255,0);
  
  fill(leftColor);
  rect(width * 4/11, height * 7/8, 40, 40);
  fill(upColor);
  rect(width * 5/11, height * 7/8, 40, 40);
  fill(downColor);
  rect(width * 6/11, height * 7/8, 40, 40);
  fill(rightColor);
  rect(width * 7/11, height * 7/8, 40, 40);
}

public void keyPressed() {
  if (key == CODED && keyCode < 255) {
    cKeys[keyCode] = true;
  }
  if (key == lkey) {
    cKeys[lkey] = true;
  }
}

public void keyReleased() {
  if (key == CODED && keyCode < 255) {
    cKeys[keyCode] = false;
  }
  if (key == lkey) {
    cKeys[lkey] = false;
  }
}
