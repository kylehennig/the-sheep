public class Memory { 
  float x;
  float y;
  int hp;
  int water;
  int day;
  int time;
  int babies; 
  boolean[] surroundings;
  int action; 
  int id; 

  static final int SHEEP = 0;
  static final int WOLF = 1;
  static final int LAKE = 2;

  //setup method(new sheep)
  public Memory(Sheep sheep) {
    //save everything the sheep should remember at a time
    this.action = sheep.action; 
    this.id = sheep.id; 
    this.x = sheep.sheepX;
    this.y = sheep.sheepY;
    this.hp = sheep.hp;
    this.water = sheep.waterLeft;
    this.babies = sheep.babies;
    //check surroundings
    surroundings = new boolean[3];
    sheep.colour = color(20, 228, 78);
    
    //if it can see a sheep
    for (Sheep sheep2 : sheeps) {
      if (sheep == sheep2) {
        continue;
      }
      if (circlesOverlap(x, y, Sheep.fov / 2, sheep2.sheepX, sheep2.sheepY, Sheep.size / 2)) {
        sheep.colour = color(255, 255, 255);
        surroundings[SHEEP] = true;
        break;
      }
    }
    
    //if it can see the lake
    if (circlesOverlap(x, y, Sheep.fov / 2, waterX, waterY, waterSize / 2)) {
      sheep.colour = color(#54F7F7);
      surroundings[LAKE] = true;
    }
    
    //if it can see a wolf
    for (Wolf wolf : wolves) {
      if (circlesOverlap(x, y, Sheep.fov / 2, wolf.wolfX, wolf.wolfY, Wolf.size / 2)) {
        sheep.colour = color(#F75454);
        surroundings[WOLF] = true;
        break;
      }
    }
    
    if(this.id == 19){// display sheep 19's memories 
      println("Sheep: "+surroundings[0]+" Wolf: "+surroundings[1]+" Lake: "+surroundings[2]+" action: "+action+" hp: "+hp+" water: "+water+" babies: "+babies); 
    }
    
  }

  //utility methods
  //takes in the (x, y) coordinates and radius of two circles
  boolean circlesOverlap(float x1, float y1, float r1, float x2, float y2, float r2) {
    float dx = x1 - x2;
    float dy = y1 - y2;    
    float dr = r1 + r2;
    return dx * dx + dy * dy <= dr * dr;
  }

  float square(float i) {
    return i * i;
  }
}