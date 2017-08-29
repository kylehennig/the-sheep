static class Theory { 
  public static enum Cause {
    NO_CAUSE(0), 
      SHEEP_IN(1), 
      SHEEP_OUT(2), 
      WOLF_IN(3), 
      WOLF_OUT(4), 
      LAKE_IN(5), 
      LAKE_OUT(6);

    public final int id;
    private Cause(int id) {
      this.id = id;
    }
  }

  public static enum Effect {
    NO_EFFECT(0), 
      HP_DOWN(7), 
      WATER_UP(8), 
      BABIES_UP(9);

    public final int id;
    private Effect(int id) {
      this.id = id;
    }
  }

  int significance;
  Cause cause;
  Effect effect;
  boolean good;

  int id;
  int action;

  boolean surrIn[];

  public Theory(Effect effect, ArrayList<Delta> deltas) {
    this.id = deltas.get(0).id; 
    Delta lastMemory = deltas.get(deltas.size() - 1);
    this.action = lastMemory.action;
    this.surrIn = lastMemory.surrIn;

    Cause cause = Cause.NO_CAUSE;
    for (int i = deltas.size() - 1; i >= 0; i--) {
      cause = findCause(deltas.get(i));
      if (cause != Cause.NO_CAUSE) {
        break;
      }
    }

    this.cause = cause;
    this.effect = effect;

    switch (effect) {
    case HP_DOWN:
      good = false;
      break;
    case WATER_UP:
    case BABIES_UP:
      good = true;
      break;
    default:
      throw new RuntimeException("You messed something up you idiots.");
    }
  }

  Cause findCause(Delta d) {
    if (d.dSurr[Memory.SHEEP]) {
      if (d.added[Memory.SHEEP]) {
        return Cause.SHEEP_IN;
      } else {
        return Cause.SHEEP_OUT;
      }
    }
    if (d.dSurr[Memory.WOLF]) {
      if (d.added[Memory.WOLF]) {
        return Cause.WOLF_IN;
      } else {
        return Cause.WOLF_OUT;
      }
    }
    if (d.dSurr[Memory.LAKE]) {
      if (d.added[Memory.LAKE]) {
        return Cause.LAKE_IN;
      } else {
        return Cause.LAKE_OUT;
      }
    }
    //no cause
    return Cause.NO_CAUSE;
  }

  void printTheory() {
    //System.out.printf("Sheep %03d thinks %-12s%-5s%-15s%-15d%n", id, stuff[cause], action, stuff[effect], significance);
  }
}  