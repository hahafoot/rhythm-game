import processing.core.*;
import ddf.minim.*;

class Menu {
  PApplet parent;
  Minim minim;
  int laneW;
  FileManager fm;
  GameStarter startGame;
  ReturnToMenu openEditor;

  Button playBtn, editorBtn, quitBtn;

  Menu(PApplet parent, Minim minim, int laneW, FileManager fm,
       GameStarter startGame, ReturnToMenu openEditor) {
    this.parent = parent;
    this.minim = minim;
    this.laneW = laneW;
    this.fm = fm;
    this.startGame = startGame;
    this.openEditor = openEditor;

    float cx = parent.width / 2;
    float by = parent.height / 2;
    playBtn = new Button("Play Game", cx, by - 80, () -> {
      String bpm = Utils.chooseFile("Select beatmap (.csv/.osu/.osz)", new String[]{"csv","osu","osz"});
      if (bpm != null) {
        String audio = Utils.chooseFile("Select audio file", new String[]{"mp3","wav","ogg"});
        if (audio != null) startGame.start(bpm, audio);
      }
    });
    editorBtn = new Button("Editor", cx, by, () -> openEditor.invoke());
    quitBtn = new Button("Quit", cx, by + 80, () -> parent.exit());
  }

  void draw() {
    for (int y = 0; y < parent.height; y++) {
      float t = map(y, 0, parent.height, 0, 1);
      int c = lerpColor(parent.color(30, 30, 60), parent.color(10, 10, 20), t);
      parent.stroke(c);
      parent.line(0, y, parent.width, y);
    }

    parent.textAlign(PConstants.CENTER, PConstants.CENTER);
    parent.textSize(64);
    parent.fill(0, 0, 0, 150);
    parent.text("OSU DUPE", parent.width/2 + 3, parent.height/2 - 180 + 3);
    parent.fill(255);
    parent.text("OSU DUPE", parent.width/2, parent.height/2 - 180);

    playBtn.draw(parent);
    editorBtn.draw(parent);
    quitBtn.draw(parent);
  }

  void mousePressed() {
    if (parent.mouseButton != PConstants.LEFT) return;
    playBtn.mousePressed(parent);
    editorBtn.mousePressed(parent);
    quitBtn.mousePressed(parent);
  }
}

class Button {
  String label;
  float x, y, w = 240, h = 60;
  Runnable action;

  Button(String label, float x, float y, Runnable action) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.action = action;
  }

  void draw(PApplet p) {
    boolean over = p.mouseX > x - w/2 && p.mouseX < x + w/2 &&
                   p.mouseY > y - h/2 && p.mouseY < y + h/2;

    p.noStroke();
    p.fill(0, 0, 0, over ? 100 : 50);
    p.rectMode(PConstants.CENTER);
    p.rect(x + 4, y + 4, w, h, 16);

    p.fill(over ? 80 : 50, 140);
    p.stroke(255);
    p.strokeWeight(2);
    p.rect(x, y, w, h, 16);

    p.fill(255);
    p.noStroke();
    p.textSize(24);
    p.textAlign(PConstants.CENTER, PConstants.CENTER);
    p.text(label, x, y);
  }

  void mousePressed(PApplet p) {
    if (p.mouseX > x - w/2 && p.mouseX < x + w/2 &&
        p.mouseY > y - h/2 && p.mouseY < y + h/2) {
      action.run();
    }
  }
}
