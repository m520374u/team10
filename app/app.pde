import java.util.ArrayList;

Stage stage;
Player player;

ArrayList<Bomb> bombs;
ArrayList<Explosion> explosions;
ArrayList<Enemy> enemies;

boolean up;
boolean down;
boolean left;
boolean right;

void setup() {

  size(600, 600);
  frameRate(60);

  stage = new Stage();

  player = new Player(40, 40);

  bombs = new ArrayList<Bomb>();
  explosions = new ArrayList<Explosion>();
  enemies = new ArrayList<Enemy>();

  // 右下付近に敵を配置
  enemies.add(new Enemy(520, 520));

}

void draw() {

  background(255);

  stage.display();

  movePlayer();

  updateBombs();

  updateExplosions();

  updateEnemies();

  player.display();

  displayGameMessage();

}

void movePlayer() {

  if (!player.alive) {
    return;
  }

  if (left) {
    player.move(-1, 0, stage);
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

void displayGameMessage() {

  if (!player.alive) {

    fill(0, 0, 0, 180);
    rect(0, 0, width, height);

    fill(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(45);
    text("GAME OVER", width / 2, height / 2);

  } else if (allEnemiesDefeated()) {

    fill(0, 0, 0, 180);
    rect(0, 0, width, height);

    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(45);
    text("STAGE CLEAR!", width / 2, height / 2);

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