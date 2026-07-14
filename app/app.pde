import java.util.ArrayList;

// ゲーム状態
final int TITLE = 0;
final int PLAYING = 1;
final int RESULT = 2;

int gameState;

Stage stage;
Player player;

ArrayList<Bomb> bombs;
ArrayList<Explosion> explosions;
ArrayList<Enemy> enemies;

boolean up;
boolean down;
boolean left;
boolean right;

boolean stageClear;

void setup() {
    
    size(600, 600);
    pixelDensity(1);
    frameRate(60);
    
    gameState = TITLE;
    
}

void draw() {
    
    background(255);
    
    if (gameState == TITLE) {
        
        displayTitleScreen();
        
    } else if (gameState == PLAYING) {
        
        updateGame();
        
    } else if (gameState == RESULT) {
        
        displayResultScreen();
        
    }
    
}

void initializeGame() {
    
    stage = new Stage();
    
    player = new Player(40, 40);
    
    bombs = new ArrayList<Bomb>();
    explosions = new ArrayList<Explosion>();
    enemies = new ArrayList<Enemy>();
    
    //敵を右下付近に配置
    enemies.add(new Enemy(520, 520));
    
    up = false;
    down = false;
    left = false;
    right = false;
    
    stageClear = false;
    
}

void updateGame() {
    
    background(255);
    
    stage.display();
    
    movePlayer();
    
    updateBombs();
    
    updateExplosions();
    
    updateEnemies();
    
    player.display();
    
    checkGameResult();
    
}

void displayTitleScreen() {
    
    background(30, 40, 70);
    
    textAlign(CENTER, CENTER);
    
    fill(255, 220, 0);
    textSize(64);
    text("BOMBER GAME", width / 2, 180);
    
    fill(255);
    textSize(24);
    text("矢印キー：移動", width / 2, 300);
    text("スペースキー：爆弾を設置", width / 2, 340);
    
    if (frameCount % 60 < 40) {
        
        fill(255);
        textSize(26);
        text("SPACEキーでスタート", width / 2, 440);
        
    }
    
}

void displayResultScreen() {
    
    background(20);
    
    textAlign(CENTER, CENTER);
    
    if (stageClear) {
        
        fill(255, 230, 0);
        textSize(55);
        text("STAGE CLEAR!", width / 2, 220);
        
    } else {
        
        fill(255, 70, 70);
        textSize(55);
        text("GAME OVER", width / 2, 220);
        
    }
    
    fill(255);
    textSize(24);
    text("Rキーでリスタート", width / 2, 340);
    text("Tキーでタイトルへ戻る", width / 2, 390);
    
}

void checkGameResult() {
    
    if (!player.alive) {
        
        stageClear = false;
        gameState = RESULT;
        return;
        
    }
    
    if (allEnemiesDefeated()) {
        
        stageClear = true;
        gameState = RESULT;
        
    }
    
}

void updateBombs() {
    
    for (int i = bombs.size() - 1; i >= 0; i--) {
        
        Bomb bomb = bombs.get(i);
        
        bomb.update();
        bomb.display();
        
        if (bomb.exploded) {
            
            bombs.remove(i);
            
        }
        
    }
    
}

void updateExplosions() {
    
    for (int i = explosions.size() - 1; i >= 0; i--) {
        
        Explosion explosion = explosions.get(i);
        
        explosion.update();
        explosion.display();
        
        if (explosion.hitPlayer(player)) {
            
            player.takeDamage(1);
            
        }
        
        for (Enemy enemy : enemies) {
            
            if (enemy.alive && explosion.hitEnemy(enemy)) {
                
                enemy.takeDamage(1);
                
            }
            
        }
        
        if (explosion.isFinished()) {
            
            explosions.remove(i);
            
        }
        
    }
    
}

void updateEnemies() {
    
    for (Enemy enemy : enemies) {
        
        enemy.updateAI(stage, player);
        enemy.display();
        
    }
    
}

void movePlayer() {
    
    if (!player.alive) {
        return;
    }
    
    if (left) {
        player.move( -1, 0, stage);
    }
    
    if (right) {
        player.move(1, 0, stage);
    }
    
    if (up) {
        player.move(0, -1, stage);
    }
    
    if (down) {
        player.move(0, 1, stage);
    }
    
}

boolean allEnemiesDefeated() {
    
    for (Enemy enemy : enemies) {
        
        if (enemy.alive) {
            return false;
        }
        
    }
    
    return true;
    
}

void keyPressed() {
    
    //タイトル画面
    if (gameState == TITLE) {
        
        if (key == ' ') {
            
            initializeGame();
            gameState = PLAYING;
            
        }
        
        return;
        
    }
    
    //プレイ中
    if (gameState == PLAYING) {
        
        if (keyCode == LEFT) {
            left = true;
        }
        
        if (keyCode == RIGHT) {
            right = true;
        }
        
        if (keyCode == UP) {
            up = true;
        }
        
        if (keyCode == DOWN) {
            down = true;
        }
        
        if (key == ' ') {
            
            player.placeBomb();
            
        }
        
        return;
        
    }
    
    //リザルト画面
    if (gameState == RESULT) {
        
        if (key == 'r' || key == 'R') {
            
            initializeGame();
            gameState = PLAYING;
            
        }
        
        if (key == 't' || key == 'T') {
            
            gameState = TITLE;
            
        }
        
    }
    
}

void keyReleased() {
    
    if (keyCode == LEFT) {
        left = false;
    }
    
    if (keyCode == RIGHT) {
        right = false;
    }
    
    if (keyCode == UP) {
        up = false;
    }
    
    if (keyCode == DOWN) {
        down = false;
    }
    
}
