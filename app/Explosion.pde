class Explosion {
    int x, y;
    int duration;
    
    Explosion(int x, int y) {
        this.x = x;
        this.y = y;
        duration = 30;
    }
    
    void update() {
        duration--;
    }
    
    void display() {
        if (isFinished()) return;
        
        pushStyle();
        noStroke();
        fill(255, 100, 0);
        rect(x * 40, y * 40, 40, 40);
        fill(255, 230, 0);
        rect(x * 40 + 8, y * 40 + 8, 24, 24);
        popStyle();
    }
    
    boolean isFinished() {
        return duration <= 0;
    }
    
    boolean hitPlayer(Player player) {
        if (!player.alive) return false;
        
        float expLeft = x * 40;
        float expRight = expLeft + 40;
        float expTop = y * 40;
        float expBottom = expTop + 40;
        
        float playerLeft = player.x + 4;
        float playerRight = player.x + 36;
        float playerTop = player.y + 4;
        float playerBottom = player.y + 36;
        
        return playerLeft < expRight && playerRight > expLeft &&
               playerTop < expBottom && playerBottom > expTop;
    }
    
    boolean hitEnemy(Enemy enemy) {
        if (!enemy.alive) return false;
        
        float expLeft = x * 40;
        float expRight = expLeft + 40;
        float expTop = y * 40;
        float expBottom = expTop + 40;
        
        float enemyLeft = enemy.x + 4;
        float enemyRight = enemy.x + 36;
        float enemyTop = enemy.y + 4;
        float enemyBottom = enemy.y + 36;
        
        return enemyLeft < expRight && enemyRight > expLeft &&
               enemyTop < expBottom && enemyBottom > expTop;
    }
}
