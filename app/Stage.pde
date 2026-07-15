import java.util.ArrayList;

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
            {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} ,
        };
        
        for (int y = 0; y < stage.length; y++) {
            for (int x = 0; x < stage[y].length; x++) {
                
                if (stage[y][x] == 2) {
                    blocks.add(new Block(x * tileSize, y * tileSize));
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
                
                rect(x * tileSize, y * tileSize, tileSize, tileSize);
                
            }
        }
        
        for (Block b : blocks) {
            b.display();
        }
        
    }
    
    boolean isWall(int x, int y) {
        
        if (x < 0 || y < 0 || x >= stage[0].length || y >= stage.length) {
            return true;
        }
        
        return stage[y][x] == 1;
    }
    
    void breakBlock(int x, int y) {
        
        for (Block b : blocks) {
            
            if (b.x ==  x * tileSize && b.y == y * tileSize) {
                
                b.breakBlock();
                
                if (random(1) < 0.3) {
                    
                    items.add(new Item(x, y));
                    
                }
                break;
                
            }
            
        }
        
    }
    
    boolean hasBlock(int x, int y) {
        
        for (Block b : blocks) {
            
            if (b.x ==  x * tileSize && 
                b.y == y * tileSize && 
                !b.isDestroyed()) {
                
                return true;
                
            }
            
        }
        
        return false;
        
    }
    
    boolean isWalkable(int gx, int gy) {
        
        return !isWall(gx, gy) && !hasBlock(gx, gy);
        
    }
    
}
