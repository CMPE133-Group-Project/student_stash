class CurrentSession {
  static String currentName = "";

  static void setCurrentName(String x) {
    currentName = x;
  }

  static String getCurrentName() {
    return currentName;
  }
}
