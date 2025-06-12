import ddf.minim.*;
import processing.core.*;
import java.util.ArrayList;
import java.io.PrintWriter;

class Editor {
  static final int TRAVEL_TIME = 3000;
  static final int HIT_OFFSET= -500;

  PApplet parent;
  Minim minim;
  AudioPlayer player;
  ArrayList<PVector> beats;
  int startTime;
  int laneW;
  FileManager fm;
  ReturnToMenu onExit;

  Editor(PApplet parent, Minim minim, int laneW,
         FileManager fm, ReturnToMenu onExit) {
    this.parent  = parent;
    this.minim  = minim;
    this.laneW  = laneW;
    this.fm  = fm;
    this.onExit = onExit;
    this.beats = new ArrayList<PVector>();
  }

  void closePlayer() {
    if (player != null) {
      player.close();
      player = null;
    }
  }

  void start() {
    String audio = Utils.chooseFile("Select audio for editor",
                                    new String[]{"mp3","wav","ogg"});
    if (audio == null) return;
    closePlayer();
    player = minim.loadFile(audio);
    player.play();startTime = parent.millis() - (int)player.position();
    beats.clear();
  }

  void draw() {

    parent.background(0);

    for (int i = 0; i < LANES; i++) {
      parent.noStroke();
      parent.fill((i%2)==0 ? 40 : 60);
      parent.rect(i*laneW, 0, laneW, parent.height - 180);
    }

    parent.stroke(255);
    parent.line(0, parent.height - 180,
                parent.width, parent.height - 180);

    if (player != null) {
      int now = parent.millis() - startTime;
      for (PVector b : beats) {
        float dt = b.y - now;
        float y  = parent.map(dt,
                              TRAVEL_TIME, HIT_OFFSET,
                              0, parent.height - 180);
        if (y < -24 || y > parent.height) continue;
        float cx = b.x * laneW + laneW/2;
        int lane = (int)b.x;
        parent.rectMode(PConstants.CENTER);
        parent.noStroke();
        switch (lane) {
          case 0: parent.fill(255,255,0); break;
          case 1: parent.fill(0,0,255);  break;
          case 2: parent.fill(255,0,0); break;
          default:parent.fill(0,255,0); break;
        }
        parent.rect(cx, y, 40, 40);
      }
    }

    for (int lane = 0; lane < LANES; lane++) {
      float cx = lane*laneW + laneW/2;
      parent.rectMode(PConstants.CENTER);
      parent.noStroke();
      switch (lane) {
        case 0: parent.fill(255,255,0); break;
        case 1: parent.fill(0,0,255);   break;
        case 2: parent.fill(255,0,0);  break;
        default:parent.fill(0,255,0); break;
      }
      parent.rect(cx, parent.height - 60, 40, 40);
    }

    parent.fill(255);
    parent.textAlign(PConstants.LEFT, PConstants.TOP);
    parent.textSize(16);
    parent.text("SPACE:Play/Pause  Z/X:Seek  D/F/J/K:Add  S:Save  L:Load  ESC:Exit", 10, 10);
    if (player != null) {
      parent.text("Time:" + nf(player.position()/1000.0,1,2) + "s", 10, 30);
    }
  }

  void keyPressed() {
    if (parent.keyCode == PConstants.ESC) {
      parent.key = 0;
      closePlayer();
      onExit.invoke();
      return;
    }
    if (player != null) {
      if (parent.key == ' ') {
        if (player.isPlaying()) player.pause();
        else {
          player.play();
          startTime = parent.millis() - (int)player.position();
        }
      }
      if (parent.key == 'Z' || parent.key == 'z') {
        int pos = (int)player.position() - 5000;
        pos = max(pos, 0);
        player.cue(pos);
        startTime = parent.millis() - pos;
      }
      if (parent.key == 'X' || parent.key == 'x') {
        int pos = (int)player.position() + 5000;
        pos = min(pos, (int)player.length());
        player.cue(pos);
        startTime = parent.millis() - pos;
      }
    }
    if (parent.key == 'D' || parent.key == 'd') addNoteAtLane(0);
    if (parent.key == 'F' || parent.key == 'f') addNoteAtLane(1);
    if (parent.key == 'J' || parent.key == 'j') addNoteAtLane(2);
    if (parent.key == 'K' || parent.key == 'k') addNoteAtLane(3);
    if (parent.key == 'S' || parent.key == 's') saveCSV();
   if (parent.key == 'L' || parent.key == 'l') loadBeatmap();
  }

  void addNoteAtLane(int lane) {
    if (player == null) return;
    int now = parent.millis() - startTime;

    beats.add(new PVector(lane, now + TRAVEL_TIME));
    parent.println("Scheduled note @ lane " + lane + " to hit in " + TRAVEL_TIME + "ms");
  }

  void saveCSV() {
    PrintWriter writer = parent.createWriter(parent.sketchPath("beatmap.csv"));
    for (PVector b : beats) {
      writer.println(int(b.x) + "," + int(b.y));
    }
    writer.flush();
    writer.close();
    parent.println("Saved " + beats.size() + " notes to " + parent.sketchPath("beatmap.csv"));
  }

  void loadBeatmap() {
    String fp = Utils.chooseFile("Choose map (.csv/.osu/.osz)", new String[]{"csv","osu","osz"});
    if (fp == null) return;
    ArrayList<Note> temp = fm.loadBeatmap(fp);
    beats.clear();
    for (Note n : temp) beats.add(new PVector(n.lane, n.time));
    parent.println("Loaded " + beats.size() + " notes");
  }
}
