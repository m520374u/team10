class Enemy extends Character {
    PImage img;
    int direction;
    int thinkTimer;
    int bombTimer;
    
    boolean isEscaping = false;
    int escapeTargetGx = -1;
    int escapeTargetGy = -1;

    Enemy(float x, float y, String imageFile) {
    super(x, y);

    try {
        img = loadImage(imageFile);
        if (img != null) img.resize(40, 40);
    } catch (Exception e) {
        img = null;
    }

    speed = 1.0;
    direction = int(random(4));
    thinkTimer = 60;
    bombTimer = 180;
}



    void updateAI(Stage stage, Player player) {

        if (!alive) return;

        updateCharacter();
        
        int gx = int((x + 20) / 40);
        int gy = int((y + 20) / 40);

        // 1. 危険エリアにいる、または逃走中だけどターゲットが安全でなくなった場合、再検索
        if (isDanger(gx, gy) ) {
            boolean found = findBestTileCurrent(stage, gx, gy);
            if (found) {
                isEscaping = true;
            } else {
                isEscaping = false;
                wanderToWalkableDir(stage);
            }
        } else if (!isDanger(gx, gy)) {
            isEscaping = false;
        }

        // 2. 移動処理
        if (isEscaping) {
            // 壁・ブロックを100%回避するスムース移動
            moveToTargetGrid(stage, gx, gy);
        } else {
            // 通常時の徘徊移動（壁・ブロックにぶつかったら即方向転換）
            thinkTimer--;
            if (thinkTimer <= 0) {
                direction = int(random(4));
                thinkTimer = int(random(40, 120));
            }
            
            float oldX = x;
            float oldY = y;
            
            // 進む先が本当に歩ける場合のみ移動
           if (direction == 0
    && stage.isWalkable(gx + 1, gy)
    && !isBombBlocking(gx + 1, gy)
    && !isDanger(gx + 1, gy)) {

    move(1, 0, stage);

}
           else if (direction == 1
    && stage.isWalkable(gx - 1, gy)
    && !isBombBlocking(gx - 1, gy)
    && !isDanger(gx - 1, gy)) {

    move(-1, 0, stage);

}
else if (direction == 2
    && stage.isWalkable(gx, gy + 1)
    && !isBombBlocking(gx, gy + 1)
    && !isDanger(gx, gy + 1)) {

    move(0, 1, stage);

}
else if (direction == 3
    && stage.isWalkable(gx, gy - 1)
    && !isBombBlocking(gx, gy - 1)
    && !isDanger(gx, gy - 1)) {

    move(0, -1, stage);

}
else {
    // 進めないなら方向転換
    direction = int(random(4));
    thinkTimer = 10;
}
            
            if (x == oldX && y == oldY) {
                direction = int(random(4));
                thinkTimer = 10;
            }
        }


        // 3. 爆弾設置判定
        if (!isEscaping && !isDanger(gx, gy)) { 
            bombTimer--;
            if (bombTimer <= 0) {
                if (canEscapeToSafetyZone(stage, gx, gy)) {
                    placeBomb();
                    isEscaping = true; 
                    bombTimer = int(random(240, 400));
                } else {
                    bombTimer = 30; 
                    direction = int(random(4));
                }
            }
        }
    }

    // 周りの歩ける（壁やブロックがない）方向をランダムに選択する
    void wanderToWalkableDir(Stage stage) {
    int gx = int((x + 20) / 40);
    int gy = int((y + 20) / 40);

    int[][] dirs = {
        {1,0},
        {-1,0},
        {0,1},
        {0,-1}
    };

    ArrayList<Integer> walkableDirs = new ArrayList<Integer>();

    for (int i = 0; i < 4; i++) {
        int tx = gx + dirs[i][0];
        int ty = gy + dirs[i][1];

        if (stage.isWalkable(tx, ty)
            && !isBombBlocking(tx, ty)) {

            walkableDirs.add(i);
        }
    }

    if (walkableDirs.size() > 0) {
        direction = walkableDirs.get(int(random(walkableDirs.size())));
        thinkTimer = int(random(40,120));
    }
}

    // 【修正】ターゲットへ向かう際、壁やブロックなどの障害物を完全に回避する移動ロジック
    void moveToTargetGrid(Stage stage, int gx, int gy) {
        float currentCenterX = x + 20;
        float currentCenterY = y + 20;
        
        float targetCenterX = escapeTargetGx * 40 + 20;
        float targetCenterY = escapeTargetGy * 40 + 20;
        
        float diffX = targetCenterX - currentCenterX;
        float diffY = targetCenterY - currentCenterY;
        
        if (abs(diffX) < 2 && abs(diffY) < 2) {
    x = escapeTargetGx * 40;
    y = escapeTargetGy * 40;

    isEscaping = false;
    escapeTargetGx = -1;
    escapeTargetGy = -1;

    return;
}
        
        // 横移動（X軸）と縦移動（Y軸）のどちらが最短か判定
        if (abs(diffX) >= abs(diffY)) {
            // 横移動がメインの時：
            // まずはY軸（上下のズレ）を現在のマスの中心に引き戻して、木箱などの角に当たるのを防ぐ
            float idealY = gy * 40;
            if (y < idealY) y += min(speed, idealY - y);
            if (y > idealY) y -= min(speed, y - idealY);
            
            // 進もうとする右(gx + 1)または左(gx - 1)が【本当に歩ける（壁・ブロックがない）】場合のみ移動
            if (diffX > 0 && stage.isWalkable(gx + 1, gy)) {
                move(1, 0, stage); 
                direction = 0;
            } else if (diffX < 0 && stage.isWalkable(gx - 1, gy)) {
                move(-1, 0, stage); 
                direction = 1;
            } else {
                // 横が詰まっている場合は、縦方向(上下)で歩ける隙間を探してスライド移動を試みる
                if (diffY > 0 && stage.isWalkable(gx, gy + 1)) { move(0, 1, stage); direction = 2; }
                else if (diffY < 0 && stage.isWalkable(gx, gy - 1)) { move(0, -1, stage); direction = 3; }
            }
        } else {
            // 縦移動がメインの時：
            // まずはX軸（左右のズレ）を現在のマスの中心に補正して吸い込ませる
            float idealX = gx * 40;
            if (x < idealX) x += min(speed, idealX - x);
            if (x > idealX) x -= min(speed, x - idealX);
            
            // 進もうとする下(gy + 1)または上(gy - 1)が【本当に歩ける（壁・ブロックがない）】場合のみ移動
            if (diffY > 0 && stage.isWalkable(gx, gy + 1)) {
                move(0, 1, stage); 
                direction = 2;
            } else if (diffY < 0 && stage.isWalkable(gx, gy - 1)) {
                move(0, -1, stage); 
                direction = 3;
            } else {
                // 縦が詰まっている場合は、横方向(左右)で歩ける隙間を探してスライド移動を試みる
                if (diffX > 0 && stage.isWalkable(gx + 1, gy)) { move(1, 0, stage); direction = 0; }
                else if (diffX < 0 && stage.isWalkable(gx - 1, gy)) { move(-1, 0, stage); direction = 1; }
            }
        }
    }

    // 「動ける（壁・ブロックがない）範囲」から、爆弾に対して最善のマスを決定
    boolean findBestTileCurrent(Stage stage, int startX, int startY) {
        ArrayList<int[]> queue = new ArrayList<int[]>();
        boolean[][] visited = new boolean[15][15];
        
        queue.add(new int[]{startX, startY});
        visited[startY][startX] = true;
        
        int[] bestTile = null;
        int maxDistFromBomb = -1; 
        
        while (queue.size() > 0) {
            int[] curr = queue.remove(0);
            int cx = curr[0];
            int cy = curr[1];
            
            // 安全地帯なら即時決定
            if (!isDanger(cx, cy)) {
                escapeTargetGx = cx;
                escapeTargetGy = cy;
                return true;
            }
            
            // 安全地帯がないとき用：爆弾から歩数（マンハッタン距離）が一番離れるマスを更新
            int dist = getMinDistanceToAnyBomb(cx, cy);
            if (dist > maxDistFromBomb) {
                maxDistFromBomb = dist;
                bestTile = curr;
            }
            
            int[][] dirs = {{1,0}, {-1,0}, {0,1}, {0,-1}};
            for (int[] d : dirs) {
                int nx = cx + d[0];
                int ny = cy + d[1];
                
                if (nx >= 0 && nx < 15 && ny >= 0 && ny < 15) {
                    boolean isStandingBomb = (nx == startX && ny == startY);
                    // 【重要】壁・木箱がなく、絶対に「動ける（歩行可能な）範囲」のみをキューに追加する
                    if ((stage.isWalkable(nx, ny) || isStandingBomb) && !visited[ny][nx]) {
                        visited[ny][nx] = true;
                        queue.add(new int[]{nx, ny});
                    }
                }
            }
        }
        
        if (bestTile != null) {
            escapeTargetGx = bestTile[0];
            escapeTargetGy = bestTile[1];
            return true;
        }
        
        return false;
    }

    int getMinDistanceToAnyBomb(int gx, int gy) {
        int minDist = 999;
        for (Bomb bomb : bombs) {
            if (bomb.exploded) continue;
            int d = abs(bomb.x - gx) + abs(bomb.y - gy);
            if (d < minDist) {
                minDist = d;
            }
        }
        return minDist;
    }

    // 爆弾設置前の安全離脱シミュレーション
    boolean canEscapeToSafetyZone(Stage stage, int bombGx, int bombGy) {
        int bombPower = 2; 

        ArrayList<int[]> queue = new ArrayList<int[]>();
        boolean[][] visited = new boolean[15][15];
        
        queue.add(new int[]{bombGx, bombGy});
        visited[bombGy][bombGx] = true;
        
        int steps = 0;
        int maxSearchSteps = 8; 

        while (queue.size() > 0 && steps < maxSearchSteps) {
            int size = queue.size();
            for (int k = 0; k < size; k++) {
                int[] curr = queue.remove(0);
                int cx = curr[0];
                int cy = curr[1];
                
                if (isHypotheticalSafe(cx, cy, bombGx, bombGy, bombPower)) {
                    escapeTargetGx = cx;
                    escapeTargetGy = cy;
                    return true;
                }
                
                int[][] dirs = {{1,0}, {-1,0}, {0,1}, {0,-1}};
                for (int[] d : dirs) {
                    int nx = cx + d[0];
                    int ny = cy + d[1];
                    
                    if (nx >= 0 && nx < 15 && ny >= 0 && ny < 15) {
                        // 進行シミュレーション上も、壁・ブロックがないマスのみを辿る
                        if (stage.isWalkable(nx, ny) && !visited[ny][nx]) {
                            visited[ny][nx] = true;
                            queue.add(new int[]{nx, ny});
                        }
                    }
                }
            }
            steps++;
        }
        return false; 
    }

    boolean isHypotheticalSafe(int tx, int ty, int bx, int by, int power) {
        if (bx == tx && by == ty) return false;
        
        if (by == ty && abs(bx - tx) <= power) {
            int start = min(bx, tx);
            int end = max(bx, tx);
            boolean shielded = false;
            for (int x = start + 1; x < end; x++) {
                if (stage.isWall(x, by) || stage.hasBlock(x, by)) shielded = true; 
            }
            if (!shielded) return false; 
        }
        
        if (bx == tx && abs(by - ty) <= power) {
            int start = min(by, ty);
            int end = max(by, ty);
            boolean shielded = false;
            for (int y = start + 1; y < end; y++) {
                if (stage.isWall(bx, y) || stage.hasBlock(bx, y)) shielded = true; 
            }
            if (!shielded) return false; 
        }
        
        return true;
    }

    boolean isDanger(int gx, int gy) {
    for (Bomb bomb : bombs) {
        if (bomb.exploded) continue;
        if (bomb.x == gx && bomb.y == gy) return true;
        if (bomb.x == gx && abs(bomb.y - gy) <= bomb.power) {
            if (isShieldedByHardWall(bomb.x, bomb.y, gx, gy)) continue;
            return true;
        }
        if (bomb.y == gy && abs(bomb.x - gx) <= bomb.power) {
            if (isShieldedByHardWall(bomb.x, bomb.y, gx, gy)) continue;
            return true;
        }
    }

    // ★追加
    for (Explosion e : explosions) {
        if (!e.isFinished() && e.x == gx && e.y == gy) {
            return true;
        }
    }

    return false;
}

    boolean isShieldedByHardWall(int bx, int by, int tx, int ty) {
        if (bx == tx) { 
            int start = min(by, ty);
            int end = max(by, ty);
            for (int y = start + 1; y < end; y++) {
                if (stage.isWall(bx, y) || stage.hasBlock(bx, y)) return true;
            }
        } else if (by == ty) { 
            int start = min(bx, tx);
            int end = max(bx, tx);
            for (int x = start + 1; x < end; x++) {
                if (stage.isWall(x, by) || stage.hasBlock(x, by)) return true;
            }
        }
        return false;
    }

   

    void display() {
        if (!alive) return;
        if (img != null) {
            image(img, x, y);
        } else {
            fill(255, 0, 0);
            rect(x, y, 40, 40);
        }
    }
}
