public class Delta {
  float x;
  float y;
  int dHP;
  int dWater;
  int dBabies; 
  boolean changed = false;
  Theory.Effect effect = Theory.Effect.NO_EFFECT;
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
    dHP = memory2.hp - memory1.hp;
    dWater = memory2.water - memory1.water;
    dBabies = memory2.babies - memory1.babies;
    x = memory2.x;
    y = memory2.y; 
    surrFin = memory2.surroundings; 
    surrIn = memory1.surroundings;
    //sheep data saved
    
    dSurr(surrIn, surrFin); //counted number of changes in two memories 
    if (dSurrNum != 0) {
      changed = true;
    }

    if (dHP < 0) {
      effect = Theory.Effect.HP_DOWN;
    } else if (dWater > 0) {
      effect = Theory.Effect.WATER_UP;
    } else if (dBabies > 0) {
      effect = Theory.Effect.BABIES_UP;
    }

    //minimum value to return a change in memory
    if (changed) {
      insert(this, sheep.deltas);
      //sheep.deltas.add(this);
      if (effect != Theory.Effect.NO_EFFECT) {
        insert(new Theory(effect, sheep.deltas), sheep.theories);//7,8,9,10
      } 
          // we gonna make a theory now
    }
    
    if(this.id == 19){
      //println("delta Hp "+this.dHP+" delta water: "+this.dWater+" delta babies: "+this.dBabies+" anything change?"+ changed); 
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