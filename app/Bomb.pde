class Bomb {
    int x, y;
    int timer;
    int power;
    boolean exploded;
    boolean ownerCanPass;
    Character owner;
    PImage img;
    
    Bomb(int x, int y, Character owner) {
        this.x = x;
        this.y = y;
        this.owner = owner;
        timer = 180;
        power = owner.bombPower;
        exploded = false;
        ownerCanPass = true;
        
        try {
            img = loadImage("bomb.png");
            if (img != null) img.resize(40, 40);
        } catch(Exception e) {
            img = null;
        }
    }
    
    void update() {
        if (exploded) return;
        
        if (ownerCanPass && !isOwnerOverlapping()) {
            ownerCanPass = false;
        }
        
        timer--;
        if (timer <= 0) {
            explode();
        }
    }
    
    void display() {
        if (exploded) return;
        
        if (img != null) {
            image(img, x * 40, y * 40);
        } else {
            fill(30);
            ellipse(x * 40 + 20, y * 40 + 20, 28, 28);
        }
    }
    
    void explode() {
        
        // すでに爆発している場合は再実行しない
        if (exploded) {
            return;
        }
        
        exploded = true;
        
        // 中心に爆風を発生
        explosions.add(new Explosion(x, y));
        
        int[] dx = {1, -1, 0, 0};
        int[] dy = {0, 0, 1, -1};
        
        for (int d = 0; d < 4; d++) {
            
            for (int i = 1; i <= power; i++) {
                
                int tx = x + dx[d] * i;
                int ty = y + dy[d] * i;
                
                // 固い壁で爆風を止める
                if (stage.isWall(tx, ty)) {
                    break;
                }
                
                // 壊せるブロック
                if (stage.hasBlock(tx, ty)) {
                    
                    explosions.add(new Explosion(tx, ty));
                    
                    stage.breakBlock(tx, ty);
                    
                    // ブロックで爆風を止める
                    break;
                }
                
                // 爆風を追加
                explosions.add(new Explosion(tx, ty));
                
                // そのマスに別の爆弾があれば連鎖爆発
                if (explodeBombAt(tx, ty)) {
                    
                    // 爆弾の位置で爆風を止める
                    break;
                }
            }
        }
        
        if (owner != null) {
            owner.currentBombs--;
            
            if (owner.currentBombs < 0) {
                owner.currentBombs = 0;
            }
        }
    }
    
    boolean isOwnerOverlapping() {
        float bombX = x * 40;
        float bombY = y * 40;
        return owner.x < bombX + 40 && owner.x + 40 > bombX && 
        owner.y < bombY + 40 && owner.y + 40 > bombY;
    }
    
    boolean explodeBombAt(int gridX, int gridY) {
        
        for (int i = 0; i < bombs.size(); i++) {
            
            Bomb otherBomb = bombs.get(i);
            
            if (otherBomb ==  this) {
                continue;
            }
            
            if (otherBomb.exploded) {
                continue;
            }
            
            if (otherBomb.x == gridX && otherBomb.y == gridY) {
                otherBomb.explode();
                return true;
            }
        }
        
        return false;
    }
}
