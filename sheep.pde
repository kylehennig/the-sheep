public class Sheep {

  //instance variables
  float sheepX;
  float sheepY;
  static final int speed = 2;
  static final int fov = 120;
  float destX = width / 2;
  float destY = height / 2;
  static final int size = 15;
  int colour;
  int id; 
  int action; 
  //sheep stats  -----------------------------
  int waterMax = 3;
  int waterLeft;
  int hp = 4;
  boolean dead = false;
  int waitTime = 1020; //takes 1/4 of a day for sheep to be ready to reproduce
  int goTime = 255; //can reproduce when 0
  int babies = 0;
  //memory stuff  ----------------------
  ArrayList<Memory> memories = new ArrayList<Memory>();
  ArrayList<Delta> deltas = new ArrayList<Delta>();
  ArrayList<Theory> theories = new ArrayList<Theory>();

  public static final int SIT = 0;
  public static final int EXPLORE = 1;
  public static final int REPRODUCE = 2;
  //setup method(new sheep)
  Sheep(float x, float y, int i) {
    id = i; 
    sheepX = x;
    sheepY = y;
    destX = sheepX;
    destY = sheepY;
    waterLeft = rand(1, waterMax);
    memories.add(new Memory(this));
  }

  //instance methods

  //---------------- main instance methods -------------------------

  void update() {
    Memory current = new Memory(this);
    memories.add(current);
    //compare to last
    if (memories.size() > 2) {
      memories.remove(0);
    }
    Delta delta = new Delta(memories.get(0), memories.get(1), this);

    ////println(deltas.size()); 
    if (atPond()) {
      waterLeft = waterMax;
    }

    action = rand(0, 2);

    if (smartSheep) {
      Theory mostSig;
      int mostSigNum = -1;
      for (Theory theory : theories) {
        if (theory.significance > mostSigNum) {
          mostSig = theory;
        }
      }
      for (Theory theory : theories) {
        if (arraysEqual(current.surroundings, theory.surrIn)) {
          if (theory.good) {
            action = theory.action;
          } else {
            while (action == theory.action) {
              action = rand(0, 2);
            }
          }
        }
      }
    }

    switch (action) {
    case EXPLORE:
      if (atDest()) {
        pickDest();
      }
      move();
      break;
    case REPRODUCE:
      if (goTime == 0) {
        reproduce();
      }
      break;
    case SIT:
      //println("im sitting"); 
      break; 
    default:
      break;
    }
    //println(goTime);
    if (goTime > 0) {
      goTime--;
    }
  } //end update

  void drawSheep() {
    if (id == 19) {
      
      
      
   
      
      
      colour = color(0);
    }
    fill(colour);
    ellipse((int) sheepX, (int) sheepY, size, size);    
    fill(0);
    text(id, (int) sheepX - size / 2, (int) sheepY - 10);
  }

  //---------------- water related --------------------------

  void endOfDay() {
    if (atPond()) {
      return;
    }
    //this function runs at end of a day (black sky) and deals with sheep hydration 
    waterLeft--;
    //println(waterLeft);
    if (waterLeft <= 0) {
      kill();
    }
  }

  boolean atPond() {
    return circlesOverlap(sheepX, sheepY, size / 2, waterX, waterY, waterSize / 2);
  }
  //---------------- reproduction related ----------------------

  void reproduce() {
    for (int i = 0; i < sheeps.size(); i++) {
      Sheep sheep = sheeps.get(i);
      if (this == sheep || sheep.goTime != 0) {
        continue;
      }
      if (circlesOverlap(sheepX, sheepY, size / 2, sheep.sheepX, sheep.sheepY, size / 2)) {
        Sheep baby = new Sheep(sheepX, sheepY, sheepId++);
        Theory mostSig = null;
        int sig = -1;
        for (Theory theory : theories) {
          if (theory.significance > sig) {
            mostSig = theory;
            sig = theory.significance;
          }
        }
        if (mostSig != null) {
          baby.theories.add(mostSig);
        }
        natality.add(baby);
        babies++;
        sheep.babies++;
        goTime = waitTime;
        sheep.goTime = sheep.waitTime;
        //println(sheeps.size()); 
        return;
      }
    }
  }

  //---------------- movement related ----------------------

  boolean circlesOverlap(float x1, float y1, float r1, float x2, float y2, float r2) {
    float dx = x1 - x2;
    float dy = y1 - y2;    
    float dr = r1 + r2;
    return dx * dx + dy * dy <= dr * dr;
  }

  void pickDest() {
    //randomly? selects destination within FOV
    float destX = rand(sheepX - fov, sheepX + fov);
    //println(destX);
    //destX is random position 
    float destY = rand(sheepY - fov, sheepY + fov);
    //println(destY);
    if (destX < size / 2 || destX > width - size / 2 || destY < 20 + size / 2 || destY > height - size / 2) {
      pickDest();
      return;
    }
    this.destX = destX;
    this.destY = destY;
  }

  //move random spot (use an explore)
  void move() {
    float dx = destX - sheepX;
    float dy = destY - sheepY;
    float r2 = dx * dx + dy * dy;
    if (r2 <= speed * speed) {
      return;
    }
    float theta = atan2(dy, dx);
    sheepX += cos(theta) * speed;
    sheepY += sin(theta) * speed;
  }

  boolean atDest() {
    float dx = destX - sheepX;
    float dy = destY - sheepY;
    float r2 = dx * dx + dy * dy;
    if (r2 <= speed * speed) {
      return true;
    }
    return false;
  }

  void kill() {
    dead = true;
    mortality.add(this);
  }

  //---------------- delta mem functions  ------------------



  //end random functions
}