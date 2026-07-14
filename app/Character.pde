class Character {
    
    float x;
    float y;
    
    float speed;
    
    int hp;
    
    boolean alive;
    boolean invincible;
    
    int invincibleTimer;
    
    Character(float x, float y) {
        
        this.x = x;
        this.y = y;
        
        speed = 2.0;
        
        hp = 1;
        
        alive = true;
        invincible = false;
        
        invincibleTimer = 0;
        
    }
    
    void move(float dx, float dy, Stage stage) {
        
        if (!alive) {
            return;
        }
        
        float nextX = x + dx * speed;
        float nextY = y + dy * speed;
        
        if (canMove(nextX, nextY, stage)) {
            
            x = nextX;
            y = nextY;
            
        }
        
    }
    
    boolean canMove(float nextX, float nextY, Stage stage) {
        
        int leftGrid = int((nextX + 4) / stage.tileSize);
        int rightGrid = int((nextX + 35) / stage.tileSize);
        
        int topGrid = int((nextY + 4) / stage.tileSize);
        int bottomGrid = int((nextY + 35) / stage.tileSize);
        
        if (!stage.isWalkable(leftGrid, topGrid)) {
            return false;
        }
        
        if (!stage.isWalkable(rightGrid, topGrid)) {
            return false;
        }
        
        if (!stage.isWalkable(leftGrid, bottomGrid)) {
            return false;
        }
        
        if (!stage.isWalkable(rightGrid, bottomGrid)) {
            return false;
        }
        
        if (isBombBlocking(leftGrid, topGrid)) {
            return false;
        }
        
        if (isBombBlocking(rightGrid, topGrid)) {
            return false;
        }
        
        if (isBombBlocking(leftGrid, bottomGrid)) {
            return false;
        }
        
        if (isBombBlocking(rightGrid, bottomGrid)) {
            return false;
        }
        
        return true;
        
    }
    
    /*
    *爆弾が移動を妨げるか判定する。
    *
    *現在自分がいるマスの爆弾は通過可能にする。
    *一度そのマスから出た後は、再び入れない。
    */
    
    boolean isBombBlocking(int gridX, int gridY) {
        
        for (Bomb bomb : bombs) {
            
            if (bomb.exploded) {
                continue;
            }
            
            if (bomb.x == gridX && bomb.y == gridY) {
                
                // 爆弾を置いた本人は、完全に抜けるまで通過可能
                if (this == bomb.owner && bomb.ownerCanPass) {
                    return false;
                }
                
                return true;
                
            }
            
        }
        
        return false;
        
    }
    
    
    void updateCharacter() {
        
        if (invincible) {
            
            invincibleTimer--;
            
            if (invincibleTimer <= 0) {
                
                invincible = false;
                
            }
            
        }
        
    }
    
    void takeDamage(int damage) {
        
        if (!alive || invincible) {
            return;
        }
        
        hp -= damage;
        
        if (hp <= 0) {
            
            die();
            
        } else {
            
            invincible = true;
            invincibleTimer = 60;
            
        }
        
    }
    
    void die() {
        
        alive = false;
        
    }
    
    void display() {
    }
    
}
