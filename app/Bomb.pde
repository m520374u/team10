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
        } catch (Exception e) {
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
        exploded = true;
        
        // 中心点に爆風を発生
        explosions.add(new Explosion(x, y));
        
        // 十字方向（右、左、下、上）に最大2マス
        int[] dx = {1, -1, 0, 0};
        int[] dy = {0, 0, 1, -1};
        
        for (int d = 0; d < 4; d++) {
            for (int i = 1; i <= power; i++) {
                int tx = x + dx[d] * i;
                int ty = y + dy[d] * i;
                
                if (stage.isWall(tx, ty)) {
                    break;
                }
                
                if (stage.hasBlock(tx, ty)) {
                    explosions.add(new Explosion(tx, ty));
                    stage.breakBlock(tx, ty);
                    break; // 木箱で爆風はストップ
                }
                
                explosions.add(new Explosion(tx, ty));
            }
        }
       if (owner != null) {
    owner.currentBombs--;
}
    }
    
    boolean isOwnerOverlapping() {
        float bombX = x * 40;
        float bombY = y * 40;
        return owner.x < bombX + 40 && owner.x + 40 > bombX &&
               owner.y < bombY + 40 && owner.y + 40 > bombY;
    }
}
