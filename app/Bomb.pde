class Bomb {
    
    int x;
    int y;
    
    int timer;
    
    int power;
    
    boolean exploded;
    boolean ownerCanPass;
    
    Player owner;
    PImage img;
    
    Bomb(int x, int y, Player owner) {
        
        this.x = x;
        this.y = y;
        
        this.owner = owner;
        
        timer = 180;
        power = owner.bombPower;
        
        exploded = false;
        ownerCanPass = true;
        
        img = loadImage("bomb.png");
        
        if (img != null) {
            img.resize(40, 40);
        }
        
    }
    
    void update() {
        
        if (exploded) {
            return;
        }
        
        // 設置者が爆弾から完全に離れたら、
        // 以降は爆弾を通れなくする
        if (ownerCanPass && !isOwnerOverlapping()) {
            ownerCanPass = false;
        }
        
        timer--;
        
        if (timer <= 0) {
            explode();
        }
        
    }
    
    void display() {
        
        if (exploded) {
            return;
        }
        
        if (img != null) {
            
            image(img,
                x * 40,
                y * 40);
            
        } else {
            
            // 画像がない場合の予備表示
            fill(30);
            ellipse(
                x * 40 + 20,
                y * 40 + 20,
                28,
                28
               );
            
        }
        
    }
    
    void explode() {
        
        exploded = true;
        
        explosions.add(new Explosion(x, y));
        
        // 右
        for (int i = 1; i <= power; i++) {
            
            if (stage.isWall(x + i, y))
                break;
            
            explosions.add(new Explosion(x + i, y));
            
            if (stage.hasBlock(x + i, y)) {
                
                stage.breakBlock(x + i, y);
                break;
                
            }
            
        }
        
        // 左
        for (int i = 1; i <= power; i++) {
            
            if (stage.isWall(x - i, y))
                break;
            
            explosions.add(new Explosion(x - i, y));
            
            if (stage.hasBlock(x - i, y)) {
                
                stage.breakBlock(x - i, y);
                break;
                
            }
            
        }
        
        // 下
        for (int i = 1; i <= power; i++) {
            
            if (stage.isWall(x, y + i))
                break;
            
            explosions.add(new Explosion(x, y + i));
            
            if (stage.hasBlock(x, y + i)) {
                
                stage.breakBlock(x, y + i);
                break;
                
            }
            
        }
        
        // 上
        for (int i = 1; i <= power; i++) {
            
            if (stage.isWall(x, y - i))
                break;
            
            explosions.add(new Explosion(x, y - i));
            
            if (stage.hasBlock(x, y - i)) {
                
                stage.breakBlock(x, y - i);
                break;
                
            }
            
        }
        
        owner.currentBombs--;
        
    }
    
    boolean isOwnerOverlapping() {
        
        float bombX = x * 40;
        float bombY = y * 40;
        
        return owner.x < bombX + 40
        && owner.x + 40 > bombX
        && owner.y < bombY + 40
        && owner.y + 40 > bombY;
        
    }
    
}