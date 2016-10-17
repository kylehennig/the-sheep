static class Theory {
  //static final String[] stuff = {
  //  "NO_CAUSE", 
  //  "SHEEP_IN", 
  //  "SHEEP_OUT", 
  //  "WOLF_IN", 
  //  "WOLF_OUT", 
  //  "LAKE_IN", 
  //  "LAKE_OUT", 
  //  "HP_DOWN", 
  //  "WATER_UP", 
  //  "BABIES_UP"
  //};
  //refer to sheep for action causes
  static final int noCause = 0;
  static final int sheepIn = 1;
  static final int sheepOut = 2;
  static final int wolfIn = 3;
  static final int wolfOut = 4;
  static final int lakeIn = 5;
  static final int lakeOut = 6;
  //effects
  static final int hpDown = 7;
  static final int waterUp = 8;
  static final int babiesUp = 9;

  int significance;
  int cause;
  int effect;
  boolean good;

  int id;
  int action;

  boolean surrIn[];

  public Theory(int effect, ArrayList<Delta> deltas) {
    this.id = deltas.get(0).id; 
    Delta lastMemory = deltas.get(deltas.size() - 1);
    this.action = lastMemory.action;
    this.surrIn = lastMemory.surrIn;

    int cause = 0;
    for (int i = deltas.size() - 1; i >= 0; i--) {
      cause = findCause(deltas.get(i));
      if (cause != 0) {
        break;
      }
    }

    this.cause = cause;
    this.effect = effect;

    switch (effect) {
    case hpDown:
      good = false;
      break;
    case waterUp:
    case babiesUp:
      good = true;
      break;
    default:
      throw new RuntimeException("You messed something up you idiots.");
    }
  }

  int findCause(Delta d) {
    if (d.dSurr[Memory.SHEEP]) {
      if (d.added[Memory.SHEEP]) {
        return sheepIn;
      } else {
        return sheepOut;
      }
    }
    if (d.dSurr[Memory.WOLF]) {
      if (d.added[Memory.WOLF]) {
        return wolfIn;
      } else {
        return wolfOut;
      }
    }
    if (d.dSurr[Memory.LAKE]) {
      if (d.added[Memory.LAKE]) {
        return lakeIn;
      } else {
        return lakeOut;
      }
    }
    //no cause
    return 0;
  }

  void printTheory() {
    //System.out.printf("Sheep %03d thinks %-12s%-5s%-15s%-15d%n", id, stuff[cause], action, stuff[effect], significance);
  }
}  