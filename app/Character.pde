class Character {
    float x, y;
    float speed;
    int maxBombs;
    int currentBombs;
    int bombPower;
    int hp;
    boolean alive;
    boolean invincible;
    int invincibleTimer;

    // 移動のクールダウン用変数
    int lastMoveTime = 0;       // 最後に移動した時刻（ミリ秒）
    int moveInterval = 200;     // 移動間隔（200ミリ秒 = 0.2秒）

    Character(float x, float y) {
        this.x = x;
        this.y = y;
        speed = 2.0;
        maxBombs = 1;
        currentBombs = 0;
        bombPower = 2;
        hp = 1;
        alive = true;
        invincible = false;
        invincibleTimer = 0;
    }

    // 1マス即時移動（前回の移動から0.2秒以上経っている場合のみ実行）
    void move(float dx, float dy, Stage stage) {
        if (!alive) return;

        // 前回の移動から0.2秒経っていない場合は何もしない
        if (millis() - lastMoveTime < moveInterval) {
            return;
        }

        // 現在のマス（グリッド座標）を取得
        int currentGx = int((x + 20) / stage.tileSize);
        int currentGy = int((y + 20) / stage.tileSize);

        // 移動先のマス
        int nextGx = currentGx + int(dx);
        int nextGy = currentGy + int(dy);

        // 移動先が歩行可能かつ爆弾で塞がれていなければ移動
        if (stage.isWalkable(nextGx, nextGy) && !isBombBlocking(nextGx, nextGy)) {
            x = nextGx * stage.tileSize;
            y = nextGy * stage.tileSize;
            lastMoveTime = millis(); // 移動した時刻を記録
        }
    }

    boolean isBombBlocking(int gridX, int gridY) {
        for (Bomb bomb : bombs) {
            if (bomb.exploded) continue;
            if (bomb.x == gridX && bomb.y == gridY) {
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
        if (!alive || invincible) return;
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

    void display() {}

    void placeBomb() {
        if (!alive) return;
        if (currentBombs >= maxBombs) return;

        int gx = int((x + 20) / 40);
        int gy = int((y + 20) / 40);

        for (Bomb bomb : bombs) {
            if (bomb.x == gx && bomb.y == gy) return;
        }

        bombs.add(new Bomb(gx, gy, this));
        currentBombs++;
    }
    boolean canMove(float nextX, float nextY, Stage stage) {
    int gx = int((nextX + 20) / stage.tileSize);
    int gy = int((nextY + 20) / stage.tileSize);

    if (!stage.isWalkable(gx, gy)) return false;
    if (isBombBlocking(gx, gy)) return false;

    return true;
}
    
}
