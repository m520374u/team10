class Explosion {

  int x;
  int y;

  int duration;

  Explosion(int x, int y) {

    this.x = x;
    this.y = y;

    // 約0.5秒間表示
    duration = 30;

  }

  void update() {

    duration--;

  }

  void display() {

    if (isFinished()) {
      return;
    }

    pushStyle();

    noStroke();

    // 外側の爆風
    fill(255, 100, 0);
    rect(
      x * 40,
      y * 40,
      40,
      40
    );

    // 中央の明るい部分
    fill(255, 230, 0);
    rect(
      x * 40 + 8,
      y * 40 + 8,
      24,
      24
    );

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

  if (!enemy.alive) {
    return false;
  }

  int enemyGridX = int((enemy.x + 20) / 40);
  int enemyGridY = int((enemy.y + 20) / 40);

  return enemyGridX == x && enemyGridY == y;

}

}