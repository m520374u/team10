class Stage {
    
    int[][] stage;
    int tileSize;
    
    ArrayList<Block> blocks;
    
    Stage() {
        tileSize = 40;
        blocks = new ArrayList<Block>();
        
        stage = new int[][]{
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} ,
            {1,0,0,2,2,2,2,2,2,2,2,2,0,0,1} ,
            {1,0,1,2,1,2,1,2,1,2,1,2,1,0,1} ,
            {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1} ,
            {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1} ,
            {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1} ,
            {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1} ,
            {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1} ,
            {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1} ,
            {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1} ,
            {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1} ,
            {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1} ,
            {1,0,1,2,1,2,1,2,1,2,1,2,1,0,1} ,
            {1,0,0,2,2,2,2,2,2,2,2,2,0,0,1} ,
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
        };
        
        for (int y = 0; y < stage.length; y++) {
            for (int x = 0; x < stage[y].length; x++) {
                if (stage[y][x] == 2) {
                    blocks.add(
                        new Block(
                        x * tileSize,
                        y * tileSize
                       )
                       );
                }
            }
        }
    }
    
    void display() {
        for (int y = 0; y < stage.length; y++) {
            for (int x = 0; x < stage[y].length; x++) {
                if (stage[y][x] == 1) {
                    fill(100);
                    
                } else {
                    fill(230);
                }
                
                rect(
                    x * tileSize,
                    y * tileSize,
                    tileSize,
                    tileSize
                   );
            }
        }
        
        for (Block block : blocks) {
            block.display();
        }
    }
    
    boolean isWall(int x, int y) {
        if (
            x < 0 || 
            y < 0 || 
            x >= stage[0].length || 
            y >= stage.length
       ) {
            return true;
        }
        
        return stage[y][x] == 1;
    }
    
    void breakBlock(int gridX, int gridY) {
        for (Block block : blocks) {
            boolean samePosition =
            block.x == gridX * tileSize && 
            block.y == gridY * tileSize;
            
            if (samePosition && !block.isDestroyed()) {
                block.breakBlock();
                createRandomItem(gridX, gridY);
                return;
            }
        }
    }
    
    void createRandomItem(int gridX, int gridY) {
        if (items == null) {
            return;
        }
        
        float randomNumber = random(100);
        
        // 20％でFireItem
        if (randomNumber < 20) {
            items.add(
                new Item(
                gridX,
                gridY,
                FIRE_ITEM
               )
               );
            
            // 20％でBombItem
        } else if (randomNumber < 40) {
            items.add(
                new Item(
                gridX,
                gridY,
                BOMB_ITEM
               )
               );
        }
        
        // 残り70％は何も出現しない
    }
    
    boolean hasBlock(int x, int y) {
        for (Block block : blocks) {
            boolean samePosition =
            block.x == x * tileSize && 
            block.y == y * tileSize;
            
            if (
                samePosition && 
                !block.isDestroyed()
           ) {
                return true;
            }
        }
        
        return false;
    }
    
    boolean isWalkable(int gridX, int gridY) {
        return
        !isWall(gridX, gridY) && 
            !hasBlock(gridX, gridY);
    }
    
    boolean isSafe(int gridX, int gridY) {
        if (!isWalkable(gridX, gridY)) {
            return false;
        }
        
        for (Bomb bomb : bombs) {
            if (bomb.exploded) {
                continue;
            }
            
            if (
                bomb.x == gridX && 
                abs(bomb.y - gridY) <= bomb.power
           ) {
                return false;
            }
            
            if (
                bomb.y == gridY && 
                abs(bomb.x - gridX) <= bomb.power
           ) {
                return false;
            }
        }
        
        return true;
    }
}