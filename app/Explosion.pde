class Explosion {
    PImage img;
    
    int x;
    int y;
    
    int duration;
    
    Explosion(int x, int y) {
        
        this.x = x;
        this.y = y;
        
        // 約0.5秒間表示
        duration = 30;
        img = loadImage("explosion.png");
        if (img != null) {
            img.resize(60, 60);
        }
        
    }
        
    void update() {
            
            duration--;
            
        }
            
           void display() {
                
                if (isFinished()) {
                    return;
                }
                
                pushStyle();
                imageMode(CENTER);
                image(img, x * 40 + 20, y * 40 + 20);
                popStyle();
                
            }
                
                boolean isFinished() {
                    
                    return duration <= 0;
                    
                }
                    
                    boolean hitPlayer(Player player) {
                        
                        int playerGridX = int((player.x + 20) / 40);
                        int playerGridY = int((player.y + 20) / 40);
                        
                        return playerGridX == x && playerGridY == y;
                        
                    }
                        
                        boolean hitEnemy(Enemy enemy) {
                            
                        if (!enemy.alive){
                                return false;
                            }
                            
                           int enemyGridX = int((enemy.x + 20) / 40);
                           int enemyGridY = int((enemy.y + 20) / 40);
                            
                           return enemyGridX == x && enemyGridY == y;
                            
                        }
                            
                        }
