class Item {
    
    int x;
    int y;
    
    boolean collected;
    
    PImage img;
    
    float animationAngle;
    
    Item(int x, int y) {
        
        this.x = x;
        this.y = y;
        
        collected = false;
        
        animationAngle = random(TWO_PI);
        
        img = loadImage("FireItem.png");
        
        if (img != null) {
            img.resize(32, 32);
        }
        
    }
    
    void update() {
        
        animationAngle += 0.08;
        
    }
    
    void display() {
        
        if (collected) {
            return;
        }
        
        float offsetY = sin(animationAngle) * 3;
        
        float drawX = x * 40 + 4;
        float drawY = y * 40 + 4 + offsetY;
        
        if (img != null) {
            
            image(img, drawX, drawY);
            
        } else {
            
            pushStyle();
            
            noStroke();
            
            fill(255, 120, 0);
            ellipse(
                x * 40 + 20,
                y * 40 + 20 + offsetY,
                24,
                24
               );
            
            fill(255, 230, 0);
            ellipse(
                x * 40 + 20,
                y * 40 + 20 + offsetY,
                12,
                12
               );
            
            popStyle();
            
        }
        
    }
    
    boolean isPlayerTouching(Player player) {
        
        int playerGridX = int((player.x + 20) / 40);
        int playerGridY = int((player.y + 20) / 40);
        
        return playerGridX == x && playerGridY == y;
        
    }
    
    void applyEffect(Player player) {
        
        if (collected) {
            return;
        }
        
        if (player.bombPower < 8) {
            player.bombPower++;
        }
        
        println("爆風範囲：" + player.bombPower);
        
        collected = true;
        
    }
    
}
