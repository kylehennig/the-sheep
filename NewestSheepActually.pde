boolean smartSheep = true;
int sheepNum = 50;
int wolfNum = 20;
int day = 0;
int timeMax = 1020;
int time = timeMax;
boolean paused = false;
boolean extinct = false;
//amimal arrays
ArrayList<Sheep> sheeps = new ArrayList<Sheep>();
ArrayList<Wolf> wolves = new ArrayList<Wolf>();
ArrayList<Sheep> natality = new ArrayList<Sheep>();
ArrayList<Sheep> mortality = new ArrayList<Sheep>();
//pond specs
int waterX = 300;
int waterY = 300;
int waterSize = 325; //diameter
//counters
int sheepId;
String version = "1.0.1";
int mode = 0; // 0 for normal, 1 for graphing
int[][] averages = new int[200][50];
// wolf target
int avgx = 0;
int avgy = 0;
PImage target;

void setup() {
  size(1500, 900);
  //creates initial population
  for (int i = 0; i < sheepNum; i++) {
    sheeps.add(new Sheep(rand(0, width), rand(20, height), i));
    sheepId++;
  }
  for (int i = 0; i < wolfNum; i++) {
    wolves.add(new Wolf(1485 - i * 2 * Wolf.size, 35, i));
  }
  field();
}
//end setup

void draw() {
  if (mode == 1) {
    println("Graph Mode");
    graphMode();
    System.exit(0);
  }

  if (!paused) {
    field();
    //imageMode(CENTER);
    //image(target, avgx, avgy);
    //imageMode(CORNER);
    fill(#EEFF44);
    ellipse(avgx, avgy, 10, 10);
    for (Sheep sheep : sheeps) {
      sheep.update();
      sheep.drawSheep();
    }
    boolean allThere = true;
    for (Wolf wolf : wolves) {
      wolf.update();
      wolf.drawWolf();
      if (!wolf.atStart()) {
        allThere = false;
      }
    }
    if (allThere) {
      //xDests[1] = rand(0, width);
      //yDests[1] = rand(20, height);
      avgx = 0;
      avgy = 0;
      for (Sheep sheep : sheeps) {
        avgx += sheep.sheepX;
        avgy += sheep.sheepY;
      }
      avgx /= sheeps.size();
      avgy /= sheeps.size();
      //xDests[1] = avgx;
      //yDests[1] = avgy;
      xDests[1] = mouseX;
      yDests[1] = mouseY;
      for (Wolf wolf : wolves) {
        wolf.pickDest();
      }
    }
    //acount for born and killed sheeps
    sheeps.addAll(natality);
    natality.clear();
    for (Sheep dead : mortality) {
      sheeps.remove(dead);
    }
    mortality.clear();

    //sheep population stats
    if (!extinct) {
      // println(sheeps.size());
      if (sheeps.isEmpty()) {
        extinct = true;
        println("wiped out on day " + day);
      }
    }
  } //end pause
}
//end draw

void graphMode() {
  for (int z = 0; z < 50; z++) {
    day = 0;
    time = timeMax;
    sheeps = new ArrayList<Sheep>();
    wolves = new ArrayList<Wolf>();
    natality = new ArrayList<Sheep>();
    mortality = new ArrayList<Sheep>();
    sheepId = 0;
    //averagePop = 0;
    for (int i = 0; i < sheepNum; i++) {
      sheeps.add(new Sheep(rand(0, width), rand(20, height), i));
      sheepId++;
    }
    for (int i = 0; i < wolfNum; i++) {
      wolves.add(new Wolf(1485 - i * 2 * Wolf.size, 35, i));
    }
    //print(sheeps.size() + "\t");
    while (true) {
      time--;
      if (time < 0) {
        time = timeMax;
        for (Sheep sheep : sheeps) {
          sheep.endOfDay();
        }
        if (sheeps.size() != 0) {
          //print(sheeps.size() + "\t");
          averages[day][z] = sheeps.size();
          //averagePop += sheeps.size();
          //print(averagePop / (double) day + "\t");
        }
        day++;
      }

      for (Sheep sheep : sheeps) {
        sheep.update();
      }
      boolean allThere = true;
      for (Wolf wolf : wolves) {
        wolf.update();
        if (!wolf.atStart()) {
          allThere = false;
        }
      }
      if (allThere) {
        xDests[1] = rand(0, width);
        yDests[1] = rand(20, height);
        for (Wolf wolf : wolves) {
          wolf.pickDest();
        }
      }
      //acount for born and killed sheeps
      sheeps.addAll(natality);
      natality.clear();
      for (Sheep dead : mortality) {
        sheeps.remove(dead);
      }
      mortality.clear();

      if (sheeps.size() < 2 || sheeps.size() > 150 || day >= 199) {
        //println();
        break;
      }
    }
  }
  for (int[] day : averages) {
    int average = 0;
    for (int pop : day) {
      average += pop;
    }
    println(average / 50.0);
  }
}

//--------------------custom functions ----------------------

void field() {
  //sky color
  fill(time / 4);
  time--;
  if (time < 0) {
    nextDay();
    if (sheeps.size() != 0) {
      println("population: "+sheeps.size());
    }
  }
  noStroke();
  //sky
  rect(0, 0, width, 20);
  //day counter
  fill(255, 0, 0);
  text(day, 7, 15);
  //mouse position
  text("x: " + mouseX + "   y: " + mouseY, width - 90, 15);
  //grass
  fill(65, 170, 35);
  rect(0, 20, width, height);
  //lake
  fill(0, 0, 255);
  ellipse(waterX, waterY, waterSize, waterSize);
}
//end field

void nextDay() {
  time = timeMax;
  for (Sheep sheep : sheeps) {
    sheep.endOfDay();
  }
  day++;
  //waterX = rand(0, width);
  //waterY = rand(20, height);
} //end nextDay

void keyPressed() {
  //function used for suspending a simulation, sets boolean “paused”.
  if (key == 'p') {
    paused = !paused;
  }
}

//---------------- misc functions ------------------

//functions used for generating random numbers within bound a,b
float rand(float min, float max) {
  return random(max - min) + min;
}

int rand(int min, int max) {
  return (int) random(max - min + 1) + min;
}

//
private static void insert(Delta d, ArrayList<Delta> list) {
  boolean done = false;
  for (int i = 0; i < list.size(); i++) {
    if (d.compareTo(list.get(i)) < 0) {
      list.add(i, d);
      done = true;
      break;
    }
  }
  if (!done) {
    list.add(d);
  }
}

private static void insert(Theory t, ArrayList<Theory> list) {
  for (Theory t2 : list) {
    if (t.cause == t2.cause && t.action == t2.action && t.effect == t2.effect) {
      t2.significance++;
      t2.printTheory();
      return;
    }
  }
  t.printTheory();
  list.add(t);
}

private static boolean arraysEqual(boolean[] array1, boolean[] array2) {
  for (int i = 0; i < array1.length; i++) {
    if (array1[i] != array2[i]) {
      return false;
    }
  }
  return true;
}