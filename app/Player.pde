class Player extends Character {
    PImage img;
    
    Player(float x, float y) {
        super(x, y);
        try {
            img = loadImage("bomberkun.png");
            if (img != null) img.resize(40, 40);
        } catch (Exception e) {
            img = null;
        }
        maxBombs = 1;
        currentBombs = 0;
        bombPower = 2;
    }
    
    void display() {
        updateCharacter();
        if (!alive) return;
        
        if (invincible && frameCount % 10 < 5) return;
        
        if (img != null) {
            image(img, x, y);
        } else {
            fill(0, 0, 255);
            rect(x, y, 40, 40);
        }
    }
}
