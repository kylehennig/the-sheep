static int[] xDests = {1485, -1};//startX, exitX, targetX
static int[] yDests = {35, -1};//startY, exitY, targetY

public class Wolf {
  //instance variables
  float wolfX;
  float wolfY;
  int startX;
  int startY;
  float destX;
  float destY;
  int destNum = 2;//0:topRight,1:random,2:start
  int id;

  final int speed = 1;
  final int fov = 100;
  static final int size = 15;

  //hunting related 
  boolean hunt = false; 
  Sheep prey;

  //setup method(new sheep)
  public Wolf(float x, float y, int id) {
    wolfX = x;
    wolfY = y;
    startX = (int) x;
    startY = (int) y;
    destX = xDests[0];
    destY = yDests[0];
    this.id = id;
  }

  //instance methods
  void update() {
    if (destNum == 1 && !hunt) {
      pickPrey();
    }
    if (hunt) {
      chase();
    }  
    if (destNum != 2 && atDest()) {
      pickDest();
    }
    move();
  } //end update

  void pickDest() {
    destNum++;
    if (destNum == 2) {
      destX = startX;
      destY = startY;
      return;
    } else if (destNum == 3) {
      destNum = 0;
    }
    destX = xDests[destNum];
    destY = yDests[destNum];
    //System.out.printf("%.0f,%.0f%n", destX, destY);
  }

  void drawWolf() {
    fill(180);
    ellipse((int) wolfX, (int) wolfY, size, size);
  }

  //move random spot (use an explore)
  void move() {
    float dx = destX - wolfX;
    float dy = destY - wolfY;
    float r2 = dx * dx + dy * dy;
    if (r2 <= speed * speed) {
      return;
    }
    float theta = atan2(dy, dx);
    wolfX += cos(theta) * speed;
    wolfY += sin(theta) * speed;
  }

  boolean atStart() {
    return destNum == 2 && atLocation(startX, startY);
  }

  boolean atDest() {
    return atLocation(destX, destY);
  }

  boolean atLocation(float x, float y) {
    float dx = x - wolfX;
    float dy = y - wolfY;
    float r2 = dx * dx + dy * dy;
    if (r2 <= speed * speed) {
      return true;
    }
    return false;
  }

  void pickPrey() {
    //hunting the closest sheep RN 
    Sheep closest = null;
    float distance = Integer.MAX_VALUE; 
    for (Sheep sheep : sheeps) {
      float dx = sheep.sheepX - wolfX;
      float dy = sheep.sheepY - wolfY;
      float r2 = dx * dx + dy * dy;
      if (r2 <= fov * fov) {
        hunt = true;
        if (r2 < distance) {
          closest = sheep;
          //println("wolf " + id + " found sheep");
          distance = r2;
        }
      }
    }
    if (closest != null) {
      //  println("sheep found by wolf " + id);
      prey = closest;
    }
  }

  void chase() {
    // println("starting chase");
    boolean attacked = false;
    float dx = destX - wolfX;
    float dy = destY - wolfY;
    float r2 = dx * dx + dy * dy;
    if (r2 <= Sheep.size * Sheep.size) {
      attacked = true;
      prey.hp -= 1;
      if (prey.hp <= 0) {
        prey.kill();
      }
      //println("chase "+sheeps.size());
    }
    if (attacked) {
      //println("chase over");
      hunt = false;
      pickDest();
      return;
    }
    destX = prey.sheepX;
    destY = prey.sheepY;
  }
}