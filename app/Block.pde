class Block {

  int x;
  int y;

  boolean breakable;
  boolean destroyed;

  Block(int x, int y) {

    this.x = x;
    this.y = y;

    breakable = true;
    destroyed = false;
  }

  void display() {

    if (!destroyed) {

      fill(180, 100, 50);
      rect(x, y, 40, 40);

    }
  }

  void breakBlock() {

    if (breakable) {
      destroyed = true;
    }

  }

  boolean isDestroyed() {
    return destroyed;
  }

}
