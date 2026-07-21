class Item {
    
    int x;
    int y;
    int type;
    
    boolean collected;
    int lifeTime;
    
    PImage img;
    
    float animationAngle;
    
    Item(int x, int y, int type) {
        this.x = x;
        this.y = y;
        this.type = type;
        
        collected = false;
        lifeTime = 600;   // 60fps × 10秒
        animationAngle = random(TWO_PI);
        
        try {
            if (type == FIRE_ITEM) {
                img = loadImage("FireItem.png");
                
            } else if (type == BOMB_ITEM) {
                img = loadImage("BombItem.png");
            }
            
            if (img != null) {
                img.resize(32, 32);
            }
            
        } catch(Exception e) {
            img = null;
        }
    }
    
   void update() {
    animationAngle += 0.08;

    lifeTime--;

    if (lifeTime <= 0) {
        collected = true;
    }
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
            displayDefaultItem(offsetY);
        }
    }
    
    void displayDefaultItem(float offsetY) {
        pushStyle();
        
        noStroke();
        
        if (type == FIRE_ITEM) {
            fill(255, 100, 0);
            
            ellipse(
                x * 40 + 20,
                y * 40 + 20 + offsetY,
                26,
                26
               );
            
            fill(255, 230, 0);
            
            ellipse(
                x * 40 + 20,
                y * 40 + 20 + offsetY,
                13,
                13
               );
            
        } else if (type == BOMB_ITEM) {
            fill(30);
            
            ellipse(
                x * 40 + 20,
                y * 40 + 22 + offsetY,
                25,
                25
               );
            
            stroke(255, 120, 0);
            strokeWeight(3);
            
            line(
                x * 40 + 23,
                y * 40 + 10 + offsetY,
                x * 40 + 29,
                y * 40 + 5 + offsetY
               );
        }
        
        popStyle();
    }
    
    boolean isPlayerTouching(Player player) {
        if (collected || !player.alive) {
            return false;
        }
        
        int playerGridX = int((player.x + 20) / 40);
        int playerGridY = int((player.y + 20) / 40);
        
        return playerGridX == x && playerGridY == y;
    }
    
    void applyEffect(Player player) {
        if (collected) {
            return;
        }
        
        if (type == FIRE_ITEM) {
            if (player.bombPower < 8) {
                player.bombPower++;
            }
            
            println(
                "FireItem取得　爆風範囲：" +
                player.bombPower
               );
            
        } else if (type == BOMB_ITEM) {
            if (player.maxBombs < 5) {
                player.maxBombs++;
            }
            
            println(
                "BombItem取得　設置可能数：" +
                player.maxBombs
               );
        }
        
        collected = true;
    }
}
