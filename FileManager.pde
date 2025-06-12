import processing.core.*;
import java.io.*;
import java.util.*;
import java.util.zip.*;

class FileManager {
  PApplet parent;
  FileManager(PApplet parent) { 
  this.parent = parent; 
}

  ArrayList<Note> loadBeatmap(String path) {
    ArrayList<Note> notes = new ArrayList<Note>();
    String pth = path.toLowerCase();
    try {
      if (pth.endsWith(".csv") || pth.endsWith(".txt")) {
        String[] lines = parent.loadStrings(path);
        for (String line : lines) {

          line = line.trim();
          if (line.isEmpty()) continue;
          String[] parts = parent.splitTokens(line, ",");
          int lane = Integer.parseInt(parts[0].trim());
          int time = Integer.parseInt(parts[1].trim());

          notes.add(new Note(lane, time));
        }
      } else if (pth.endsWith(".osu")) {
        String[] lines = parent.loadStrings(path);
        boolean inHit = false;
        for (String line : lines) {
          line = line.trim();
          if (line.equals("[HitObjects]")) { inHit = true; continue; }
          if (!inHit) continue;
          if (line.startsWith("[")) break;
          String[] parts = parent.split(line, ',');

          int x = Integer.parseInt(parts[0]);
          int time = Integer.parseInt(parts[2]);
          int lane = parent.constrain(parent.floor(x/(512.0/4.0)),0,3);
          notes.add(new Note(lane,time));

        }
      } else if (pth.endsWith(".osz")) {
        ZipFile zf = new ZipFile(path);
        for (Enumeration<?extends ZipEntry> e = zf.entries(); e.hasMoreElements();) {
          ZipEntry ze = e.nextElement();
          if (ze.getName().toLowerCase().endsWith(".osu")) {
            BufferedReader br = new BufferedReader(new InputStreamReader(zf.getInputStream(ze)));
            String line; boolean inHit = false;
            while ((line = br.readLine()) != null) {
              line = line.trim();
              if (line.equals("[HitObjects]")) { inHit = true; continue; }
              if (!inHit) continue;
              if (line.startsWith("[")) break;
              String[] parts = parent.split(line, ',');
              int x = Integer.parseInt(parts[0]);
              int time = Integer.parseInt(parts[2]);
              int lane = parent.constrain(parent.floor(x/(512.0/4.0)),0,3);
              notes.add(new Note(lane,time));
            }

            br.close();
            break;
          }
        }
        zf.close();
      }
    } catch (Exception e) {
      parent.println("Error loading beatmap:");
      e.printStackTrace();
    }
    return notes;
  }
}
