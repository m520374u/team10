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

  // 描画
  void display() {

    if (!destroyed) {

      fill(180, 100, 50);
      rect(x, y, 40, 40);

    }
  }

  // ブロックを壊す
  void breakBlock() {

    if (breakable) {
      destroyed = true;
    }

  }

  // 壊れたか判定
  boolean isDestroyed() {
    return destroyed;
  }

}
