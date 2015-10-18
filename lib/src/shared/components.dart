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

class FollowsRoad extends Component {}

class Road extends Component {}

class Present extends Component {}

class Cursor extends Component {}

class Tile extends Component {}

class Tower extends Component {
  String name;
  int range;
  int rangeLevel;
  int bulletVelocityLevel;
  int bulletDamageLevel;
  int cooldownLevel;
  double bulletVelocity;
  double rotation;
  Tower(this.name) {
    this.range = towerRanges[name];
    this.bulletVelocity = bulletVelocities[name];
    this.rotation = 0.0;
    this.rangeLevel = 0;
    this.bulletVelocityLevel = 0;
    this.bulletDamageLevel = 0;
    this.cooldownLevel = 0;
  }
  int get rangeUpgradeCost => pow(2, rangeLevel) * towerCosts[name] ~/ 5;
  int get bulletVelocityUpgradeCost => pow(2, bulletVelocityLevel) * towerCosts[name] ~/ 5;
  int get bulletDamageUpgradeCost => pow(2, bulletDamageLevel) * towerCosts[name] ~/ 5;
  int get cooldownUpgradeCost => pow(2, cooldownLevel) * towerCosts[name] ~/ 5;
}

class Cooldown extends Component {
  double cooldown;
  double maxCooldown;
  Cooldown(this.maxCooldown) {
    this.cooldown = 0.0;
  }
}

class Bullet extends Component {
  int damage;
  Bullet(this.damage);
}

class BlocksTower extends Component {}

class Enemy extends Component {
  String name;
  int worth;
  double health;
  double maxHealth;
  Enemy(this.name, double killMod) {
    this.health = enemyHealth[name] * killMod * killMod;
    this.maxHealth = enemyHealth[name] * killMod * killMod;
    this.worth = (enemyWorth[name] * killMod * killMod).toInt();
  }
}

class SelectedTower extends Component {
  String name;
  SelectedTower(this.name);
}

class ExpirationTimer extends Component {
  double timer;
  ExpirationTimer(this.timer);
}

class Inventory extends Component {
  int cost;
  Inventory(this.cost);
}

class UpgradeMenu extends Component {}
