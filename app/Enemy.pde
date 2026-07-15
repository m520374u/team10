class Enemy extends Character {
    
    PImage img;
    
    int direction;
    int thinkTimer;
    
    Enemy(float x, float y) {
        
        super(x, y);
        
        img = loadImage("bomberkun2.png");
        
        if (img != null) {
            img.resize(40, 40);
        }
        
        speed = 1.0;
        
        direction = int(random(4));
        
        thinkTimer = 60;
        
    }
    
    void updateAI(Stage stage, Player player) {
        
        if (!alive) {
            return;
        }
        
        updateCharacter();
        
        thinkTimer--;
        
        if (thinkTimer <= 0) {
            
            direction = int(random(4));
            thinkTimer = int(random(30, 100));
            
        }
        
        float oldX = x;
        float oldY = y;
        
        if (direction == 0) {
            
            move(1, 0, stage);
            
        } else if (direction == 1) {
            
            move( -1, 0, stage);
            
        } else if (direction == 2) {
            
            move(0, 1, stage);
            
        } else if (direction == 3) {
            
            move(0, -1, stage);
            
        }
        
        
        if (x == oldX && y == oldY) {
            direction = int(random(4));
            thinkTimer = 10;
        }
        
    }
    
    void checkPlayerCollision(Player player) {
        
        if (!alive || !player.alive) {
            return;
        }
        
        boolean hit =
        x < player.x + 34 && 
        x + 34 >player.x && 
        y < player.y + 34 && 
        y + 34 >player.y;
        
        if (hit) {
            
            player.takeDamage(1);
            
        }
        
    }
    
    void display() {
        
        if (!alive) {
            return;
        }
        
        if (img != null) {
            
            image(img, x, y);
            
        } else {
            
            fill(255, 0,0);
            rect(x, y, 40, 40);
            
        }
        
    }
    
}