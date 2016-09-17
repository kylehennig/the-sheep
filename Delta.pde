public class Delta {
  float x;
  float y;
  int dHP;
  int dWater;
  int dBabies; 
  int changed = -1;
  int action; 

  boolean[] surrIn;
  boolean[] surrFin;
  //differences in surroundings
  int dSurrNum;//sorting variable
  boolean[] dSurr = { false, false, false };//was there a change is surroundings?
  boolean[] added = { false, false, false };//if so, was it newly introduced?
  //havent used yet 
  int significance;
  int id; 

  public Delta(Memory memory1, Memory memory2, Sheep sheep) {
    this.id = sheep.id; 
    action = memory1.action; 
    //might be taking in the wrong action RN 
    dHP = memory2.hp - memory1.hp;
    dWater = memory2.water - memory1.water;
    dBabies = memory2.babies - memory1.babies;
    x = memory2.x;
    y = memory2.y; 
    surrFin = memory2.surroundings; 
    surrIn = memory1.surroundings;
    dSurr(surrIn, surrFin); 
    //vars set

    //if (dSurrNum != 0 || dHP != 0 || dWater != 0 || dBabies != 0) {
    //  changed = true;
    //}

    if (dSurrNum != 0) {
      changed = 0;
    }

    if (dHP < 0) {
      changed = Theory.hpDown;
    } else if (dWater > 0) {
      changed = Theory.waterUp;
    } else if (dBabies > 0) {
      changed = Theory.babiesUp;
    }

    //minimum value to return a change in memory
    if (changed != -1) {
      insert(this, sheep.deltas);
      //sheep.deltas.add(this);
      if (changed > 0) {
        insert(new Theory(changed, sheep.deltas), sheep.theories);//7,8,9,10
      } 
      //******************************      // we gonna make a theory now
    }
  }//end constructor method

  private void dSurr(boolean[] init, boolean[] fin) {
    for (int i = 0; i < fin.length; i++) {
      if (init[i] && !fin[i]) {
        dSurrNum++; 
        dSurr[i] = true;
      } else if (!init[i] && fin[i]) {
        dSurrNum++; 
        dSurr[i] = true;
        added[i] = true;
      }
    }
  }//end dSurr

  private int compareTo(Delta d) {
    return dSurrNum - d.dSurrNum;
  }
}//end class