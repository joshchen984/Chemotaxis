Bacteria[] bac;
Food[] food;
boolean[] foodExists;
 
 color c = color(100,0,0);
void setup()   
 {     
    int x, y;
    size(500,500);
    background(255,255,255);
    frameRate(30);
    
    foodExists = new boolean[10];
    food = new Food[10];
    
    for(int i = 0; i < 10; i++){
      foodExists[i] = false;
      x = (int)(Math.random() * 451) + 25;
      y = (int)(Math.random() * 451) + 25;
      food[i] = new Food(x,y); 
    }
    int numBac = 20;
    bac = new Bacteria[numBac];
    
    for(int i = 0; i < numBac;i++){
      x = (int)(Math.random() * 451) + 25;
      y = (int)(Math.random() * 451) + 25;
      bac[i] =  new Bacteria(x, y, c);
    }
 }   


void draw()   
 {    
  int x, y;
  background(255);
  for(int i = 0; i < 10; i++){
    if(Math.random() > 0.99 && foodExists[i] == false){ //making food appear randomly
      foodExists[i] = true;
      x = (int)(Math.random() * 451) + 25;
      y = (int)(Math.random() * 451) + 25;
      food[i].setCoords(x, y);
    }
    
    if(foodExists[i]){ //checks if each food exists
      if(food[i].attract(bac)){ //checks if food was eaten
        foodExists[i] = false;
      }
      food[i].show();
    }
  }
  for (Bacteria b: bac){
    b.move();
    b.show();
    if(b.decreaseLife()){
      
      //remove b from array
    }
  }
 }  

 
class Bacteria    
 {     
    private int lifeforce; //how much life it has left
    private color col;
    private float x, y;
    private float[] bias;
    float changeX, changeY;
    Bacteria(float xx, float yy, color c){
      x = xx;
      y = yy;
      col = c;
      bias = new float[]{0,0};
      changeX = 0;
      changeY = 0;
    }
    
    float[] getPos(){
      return new float[]{x, y};
    }
    
    boolean decreaseLife(){
      lifeforce--;
      if(lifeforce == 0){
        return true;
      }
      return false;
    }
    boolean isCollide(float distance){
      if(distance < 10){
        return true;
      }
      return false;
    }
    void eat(int life){
      lifeforce +=life;
    }
    
    //changes bias to go towards food
    void addBias(int foodX, int foodY, float distance)
    {
        if(x > foodX)
        {
          bias[0] -=1.5 * (x - foodX)/distance;
        }else if (x < foodX){
          bias[0] +=1.5 * (foodX - x)/distance;
        }
        
        if(y > foodY)
        {
          bias[1] -=2 * (y - foodY)/distance;
        }else if (y < foodY){
          bias[1] +=2 * (foodY - y)/distance;
        }
    }
    
    void move()
    {
     //reversing bias if out of screen
     if(x < 0){
       bias[0] += 0.7;
     }else if(x > 500){
       bias[0] -=0.7;
     }
     if(y < 0){
       bias[1] += 0.7;
     }else if(y > 500){
       bias[1] -=0.7;
     }
     
     //making bacteria not want to be near edge
     if(x < 100){
       bias[0] +=0.3;
     }else if(x > 400){
       bias[0] -= 0.3;
     }
     //making bacteria not want to be near edge
     if(y < 100){
       bias[1] +=0.3;
     }else if(y > 400){
       bias[1] -= 0.3;
     }
     if(Math.random() > 0.6){
       changeX = (int)(Math.random() * 9)-4+bias[0];
       changeY = (int)(Math.random() * 9)-4 + bias[1];
     }
     x += changeX;
     y += changeY;
     bias[0] = changeX/10;
     bias[1] = changeY/10;
    }
    
    void show()
    {
      fill(col);
      ellipse(x, y, 10,10);
    }
 }    
 
class Food{
  int x, y;
  int power; //bacteria within power pixels will be attracted to it
  int life;
  Food(int xx,int yy){
    x = xx;
    y = yy;
    power = 200;
    life =(int)( Math.random() * 150);
  }
  
  void setCoords(int xx, int yy){
    x = xx;
    y = yy;
  }
  
  boolean attract(Bacteria[] bac){
    float[] bPos;
    float distance;
    for(Bacteria b:bac){
      bPos = b.getPos();
      distance = (float)(Math.sqrt( Math.pow(bPos[0]-x, 2) + Math.pow(bPos[1]-y,2)));
      
      if(distance <= power){
        b.addBias(x, y, distance);
        if(b.isCollide(distance)){
          b.eat(life);
          return true;
        }
      }
    }
    return false;
  }
  
  void show(){
    fill(0,255,0);
    ellipse(x, y, 10,10);
  }
}
