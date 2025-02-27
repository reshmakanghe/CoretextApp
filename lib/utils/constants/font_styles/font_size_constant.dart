enum FontSize { twentyFive, sixteen }

class FontSizeHelper {
  static double setFont(FontSize size) {
    switch (size) {
      case FontSize.twentyFive:
        return 25.0;
      case FontSize.sixteen:
        return 16.0;
      default:
        return 20.0;
    }
  }
}
