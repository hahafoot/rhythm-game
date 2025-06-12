import ddf.minim.*;
import java.util.ArrayList;
import processing.core.*;

interface GameStarter { void start(String beatmapPath, String audioPath); }
interface ReturnToMenu { void invoke(); }

final int MODE_MENU = 1;
final int MODE_GAME = 2;
final int MODE_EDITOR = 3;
int mode = MODE_MENU;

final int GOOD_WINDOW = 80;
final int MEH_WINDOW  = 150;
final int OK_WINDOW   = 250;

final int TRAVEL_TIME = 3000;
final int HIT_LINE_OFFSET = 180;
final int PIXEL_BEFORE = 40;
final int PIXEL_AFTER = 40;

String ratingText = "";
int ratingStart = 0;
final int RATING_DURATION = 500;

Minim minim;
AudioPlayer song;
ArrayList<Note> notes;
int currentIdx = 0;
int startTime= 0;

final int LANES = 4;
int laneW;

FileManager fileManager;
Editor editor;
Menu menu;

int goodHits = 0, mehHits = 0, okHits = 0, missHits = 0;
int combo = 0;

int activeLane = -1;
int activeStart = 0;
int activeDuration= 150;

void settings() {
  fullScreen(P2D);
}

void setup() {
  frameRate(120);
  minim = new Minim(this);
  notes = new ArrayList<Note>();
  fileManager = new FileManager(this);
  laneW  = width / LANES;

  editor = new Editor(this, minim, laneW, fileManager, () -> {
    editor.closePlayer();
    mode = MODE_MENU;
  });
  menu = new Menu(this, minim, laneW, fileManager,
    (beatmap, audio) -> startGameplay(beatmap, audio),
    () -> {
      editor.start();
      mode = MODE_EDITOR;
    }
  );
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  switch(mode) {
    case MODE_MENU:   menu.draw();  break;
    case MODE_GAME:   runGame(); break;
    case MODE_EDITOR: editor.draw(); break;
  }
}

void mousePressed() {
  if (mouseButton != LEFT) return;
  if (mode == MODE_MENU) menu.mousePressed();
  else if (mode == MODE_GAME) hitLane(constrain(mouseX / laneW, 0, LANES-1));
}

void runGame() {
  if (song == null) return;
  int now = (int)song.position();
  float hitY = height - HIT_LINE_OFFSET;

  for (int i = currentIdx; i < notes.size(); i++) {
    Note n = notes.get(i);
    float dt = n.time - now;

    float y = map(dt, TRAVEL_TIME, 0, 0, hitY);
    if (y > height) { currentIdx = i + 1; continue; }
    if (y < 0) continue;

    float cx = n.lane * laneW + laneW/2;
    rectMode(CENTER);
    noStroke();
    switch(n.lane) {
      case 0: fill(255,255,0); break;
      case 1: fill(0,0,255);  break;
      case 2: fill(255,0,0); break;
      default: fill(0,255,0); break;
    }
    rect(cx, y, 40, 40);
  }

  float hitYPos = height - HIT_LINE_OFFSET;
  for (int lane = 0; lane < LANES; lane++) {
    float cx = lane * laneW + laneW/2;
    rectMode(CENTER);
    if (lane == activeLane && millis() - activeStart < activeDuration) {
      fill(255);
      stroke(200);
      strokeWeight(3);
    } else {
      noStroke();
      switch(lane) {
        case 0: fill(255,255,0); break;
        case 1: fill(0,0,255);  break;
        case 2: fill(255,0,0); break;
        default: fill(0,255,0); break;
      }
    }
    rect(cx, hitYPos, 40, 40);
    strokeWeight(1);
  }

  if (millis() - ratingStart < RATING_DURATION) {
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(64);
    text(ratingText, width/2, height/2);
  }

  fill(255);
  textAlign(LEFT, TOP);
  textSize(28);
  text("Combo: " + combo, 10, 10);
  textSize(20);
  text("Good:" + goodHits + "  Meh:" + mehHits + "  OK:" + okHits + "  Miss:" + missHits, 10, 50);
}

void keyPressed() {
  if (mode == MODE_GAME) handleGameKey(key);
  else if (mode == MODE_EDITOR) editor.keyPressed();
}

void handleGameKey(char kChar) {
  if (song == null) return;
  char k = Character.toUpperCase(kChar);
  if (k == ' ') {
    if (song.isPlaying()) song.pause();
    else { song.play(); startTime = millis() - (int)song.position(); }
    return;
  }
  if (k == ESC) {
    key = 0;
    song.close();
    mode = MODE_MENU;
    return;
  }
  int lane = "DFJK".indexOf(k);
  if (mode == MODE_GAME && lane != -1) hitLane(lane);
}

void hitLane(int lane) {
  activeLane = lane;
  activeStart = millis();
  if (song == null) return;

  int now = (int)song.position();
  Note best = null;
  int bestDiff = OK_WINDOW + 1;
  for (Note n : notes) {
    if (n.lane != lane) continue;
    int diff = abs(n.time - now);
    if (diff < bestDiff) { bestDiff = diff; best = n; }
  }

  float hitY = height - HIT_LINE_OFFSET;
  if (best != null) {
    float dt = best.time - now;
    float y = map(dt, TRAVEL_TIME, 0, 0, hitY);
    if (y >= hitY - PIXEL_BEFORE && y <= hitY + PIXEL_AFTER && bestDiff <= OK_WINDOW) {
      if (bestDiff <= GOOD_WINDOW) {
        goodHits++;
        ratingText = "Good";
      } else if (bestDiff <= MEH_WINDOW) {
        mehHits++;
        ratingText = "Meh";
      } else {
        okHits++;
        ratingText = "OK";
      }
      ratingStart = millis();
      combo++;
      notes.remove(best);
      return;
    }
  }
  missHits++;
  ratingText = "Miss";
  ratingStart = millis();
  combo = 0;
}

void startGameplay(String beatmapPath, String audioPath) {
  notes = fileManager.loadBeatmap(beatmapPath);
  if (song != null) song.close();
  song = minim.loadFile(audioPath);
  song.play();
  currentIdx = 0;
  startTime = millis();
  goodHits = mehHits = okHits = missHits = combo = 0;
  activeLane = -1;
  mode = MODE_GAME;
}
