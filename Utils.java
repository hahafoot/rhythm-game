import javax.swing.*;
import javax.swing.filechooser.*;

public class Utils {
  public static String chooseFile(String title, String[] extensions) {
    JFileChooser chooser = new JFileChooser();
    chooser.setDialogTitle(title);
    if (extensions != null && extensions.length > 0) {
      FileNameExtensionFilter filter =
        new FileNameExtensionFilter(title, extensions);
      chooser.setFileFilter(filter);
    }
    int result = chooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
      return chooser.getSelectedFile().getAbsolutePath();
    }
    return null;
  }
}
