class Note {
  private PVector notePos;
  private color noteColor;
  public Note(PVector note, color noteColor) {
    this.noteColor = noteColor;
    notePos = new PVector((width * note.x /11) + (width * 3/11),0);
  }
  
  public void drawNote(int bpm) {
    fill(noteColor);
    rect(notePos.x, notePos.y, 40,40);
    notePos.y += ((0.0 + height * 7.0/8) * bpm/3600.0 / 4 );
  }
}
