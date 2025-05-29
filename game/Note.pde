class Note {
  private PVector notePos;
  private color noteColor;
  public Note(PVector note) {
    switch ((int)note.x) {
      case 1:
        noteColor = color(255,0,0);
        break;
    }
    notePos = new PVector((width * note.x /11) + (width * 3/11),0);
  }
  
  public void drawNote() {
    clear();
    fill(noteColor);
    rect(notePos.x, notePos.y, 40,40);
    notePos.y += height * 1/60 / 5;
  }
}
