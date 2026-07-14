class Bomb {

  int x;
  int y;

  int timer;

  int power;

  boolean exploded;

  Player owner;

  Bomb(int x, int y, Player owner) {

    this.x = x;
    this.y = y;

    this.owner = owner;

    timer = 180;      // 約3秒
    power = owner.bombPower;

    exploded = false;

  }

  void update() {

    if (exploded) {
      return;
    }

    timer--;

    if (timer <= 0) {

      explode();

    }

  }

  void display() {

    if (exploded) {
      return;
    }

    fill(30);

    ellipse(
      x * 40 + 20,
      y * 40 + 20,
      28,
      28
    );

    fill(255);

    ellipse(
      x * 40 + 15,
      y * 40 + 15,
      6,
      6
    );

  }

  void explode() {

    exploded = true;

    explosions.add(new Explosion(x, y));

    // 右
    for (int i = 1; i <= power; i++) {

      if (stage.isWall(x + i, y))
        break;

      explosions.add(new Explosion(x + i, y));

      if (stage.hasBlock(x + i, y)) {

        stage.breakBlock(x + i, y);
        break;

      }

    }

    // 左
    for (int i = 1; i <= power; i++) {

      if (stage.isWall(x - i, y))
        break;

      explosions.add(new Explosion(x - i, y));

      if (stage.hasBlock(x - i, y)) {

        stage.breakBlock(x - i, y);
        break;

      }

    }

    // 下
    for (int i = 1; i <= power; i++) {

      if (stage.isWall(x, y + i))
        break;

      explosions.add(new Explosion(x, y + i));

      if (stage.hasBlock(x, y + i)) {

        stage.breakBlock(x, y + i);
        break;

      }

    }

    // 上
    for (int i = 1; i <= power; i++) {

      if (stage.isWall(x, y - i))
        break;

      explosions.add(new Explosion(x, y - i));

      if (stage.hasBlock(x, y - i)) {

        stage.breakBlock(x, y - i);
        break;

      }

    }

    owner.currentBombs--;

  }

}