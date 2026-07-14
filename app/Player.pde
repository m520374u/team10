class Player extends Character {
    
    PImage img;
    
    int maxBombs;
    int currentBombs;
    int bombPower;
    
    Player(float x, float y) {
        
        super(x, y);
        
        img = loadImage("bomberkun.png");
        img.resize(40, 40);
        
        maxBombs = 1;
        currentBombs = 0;
        bombPower = 2;
        
    }
    
    void display() {
        
        updateCharacter();
        
        if (!alive) {
            return;
        }
        
        if (invincible && frameCount % 10 < 5) {
            return;
        }
        
        image(img, x, y);
        
    }
    
    void placeBomb() {
        
        if (!alive) {
            return;
        }
        
        if (currentBombs >= maxBombs) {
            return;
        }
        
        int gx = int((x + 20) / 40);
        int gy = int((y + 20) / 40);
        
        for (Bomb bomb : bombs) {
            
            if (bomb.x == gx && bomb.y == gy) {
                return;
            }
            
        }
        
        bombs.add(new Bomb(gx, gy, this));
        
        currentBombs++;
        
    }
    
}