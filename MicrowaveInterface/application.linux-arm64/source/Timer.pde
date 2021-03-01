class Timer{
  int time_entered;
  int start_time;
  int elapsed_time;
  float per_done;
  int time_remaining;
  Boolean paused = false;
  int pause_time;
  int unpause_time;
  int time_paused = 0;
  Boolean timerOn = false;
  Boolean timerEnded = false;
  
  Timer(int timeEntered, int startTime, Boolean on){
    time_entered = timeEntered;
    start_time = startTime;
    timerOn = on;
  }
  
  int timeRemaining(){
    if (!paused){
      int curr_s = second();
      int curr_m = minute();
      int curr_time = curr_m*60 + curr_s;
      elapsed_time = curr_time - (start_time + time_paused);
      time_remaining = time_entered - elapsed_time;
      if (time_remaining == 0){
        timerEnd();
      }
      return time_remaining;
    } else return time_remaining;
  
  }
  
  float percentDone(){
    per_done = float(elapsed_time) / float(time_entered);
    return per_done;
  }
  
  void pause(){
    paused = true;
    int curr_s = second();
    int curr_m = minute();
    int curr_time = curr_m*60 + curr_s;
    pause_time = curr_time;
  }
  
  void unpause(){
    int curr_s = second();
    int curr_m = minute();
    int curr_time = curr_m*60 + curr_s;
    unpause_time = curr_time;
    time_paused = time_paused + (unpause_time - pause_time);
    paused = false;
  }
  
  void timerEnd(){
    paused = true;
    timerEnded = true;
  }
  
  
  
  
}
