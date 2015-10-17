part of shared;

class Position extends Component {
  Vector2 value;
  Position(num x, num y) : value = new Vector2(x.toDouble(), y.toDouble());
}

class GridPosition extends Component {
  int x, y;
  GridPosition(this.x, this.y);
}

class Velocity extends Component {
  Vector2 value;
  Velocity(num x, num y) : value = new Vector2(x.toDouble(), y.toDouble());
}

class SpriteComponent extends Component {
  String name;
  SpriteComponent(this.name);
}

class Snowflake extends Component {}

class Cursor extends Component {}

class Tile extends Component {}

class Tower extends Component {
  String name;
  int range;
  double cooldown;
  double maxCooldown;
  double ammoVelocity;
  double bulletVelocity;
  double rotation;
  Tower(this.name) {
    this.cooldown = 0.0;
    this.range = towerRanges[name];
    this.maxCooldown = towerCooldowns[name];
    this.bulletVelocity = bulletVelocities[name];
    this.rotation = 0.0;
  }
}

class Bullet extends Component {
  double collisionTimer;
  Bullet(this.collisionTimer);
}

class BulletCollision extends Component {}

class BlocksTower extends Component {}

class Enemy extends Component {
  String name;
  double health;
  double maxHealth;
  Enemy(this.name) {
    this.health = enemyHealth[name];
    this.maxHealth = enemyHealth[name];
  }
}

class SelectedTower extends Component {
  String name;
  SelectedTower(this.name);
}
