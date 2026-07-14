import java.util.ArrayList;

class Stage {

  int[][] map;
  int tileSize;

  ArrayList<Block> blocks;

  Stage() {

    tileSize = 40;

    blocks = new ArrayList<Block>();

   map = new int[][]{
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,2,2,2,2,2,2,2,2,2,0,0,1},
  {1,0,1,2,1,2,1,2,1,2,1,2,1,0,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,2,1,2,1,2,1,2,1,2,1,2,1,2,1},
  {1,2,2,2,2,2,2,2,2,2,2,2,2,2,1},
  {1,0,1,2,1,2,1,2,1,2,1,2,1,0,1},
  {1,0,0,2,2,2,2,2,2,2,2,2,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
};

    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {

        if (map[y][x] == 2) {
          blocks.add(new Block(x * tileSize, y * tileSize));
        }

      }
    }

  }

  void display() {

    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {

        if (map[y][x] == 1) {
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

    if (x < 0 || y < 0 || x >= map[0].length || y >= map.length) {
      return true;
    }

    return map[y][x] == 1;
  }

  void breakBlock(int x, int y) {

    for (Block b : blocks) {

      if (b.x == x * tileSize && b.y == y * tileSize) {

        b.breakBlock();

      }

    }

  }

  boolean hasBlock(int x, int y) {

    for (Block b : blocks) {

      if (b.x == x * tileSize &&
          b.y == y * tileSize &&
          !b.isDestroyed()) {

        return true;

      }

    }

    return false;

  }

}
