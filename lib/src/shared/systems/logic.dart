part of shared;

class MovementSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  Mapper<Velocity> vm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Position, Velocity]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    var v = vm[entity];

    p.value = p.value + v.value * world.delta;
  }
}

class EnemyInRangeDetectionSystem extends EntitySystem {
  Mapper<Position> pm;
  Mapper<Velocity> vm;
  Mapper<GridPosition> gpm;
  Mapper<Tower> tm;
  GridPositionManager gpManager;
  GroupManager gm;
  EnemyInRangeDetectionSystem()
      : super(Aspect.getAspectForAllOf([Position, Velocity, Enemy]));

  @override
  void processEntities(Iterable<Entity> entities) {
    var towerEntities = gpManager.getTowers();
    towerEntities.forEach((towerEntity) {
      var t = tm[towerEntity];
      if (t.cooldown <= 0.0) {
        entities.forEach((entity) {
          var tgp = gpm[towerEntity];
          var p = pm[entity];
          var v = vm[entity];
          var tpx = tgp.x * 32;
          var tpy = tgp.y * 32;
          var distX = p.value.x + 16 - tpx;
          var distY = p.value.y + 16 - tpy;
          var distanceSqared = distX * distX + distY * distY;
          if (distanceSqared < t.range * t.range) {
            var distance = sqrt(distanceSqared);
            var bulletTime = distance / t.bulletVelocity;
            var angle = atan2(
                distY + v.value.y * bulletTime, distX + v.value.x * bulletTime);
            t.rotation = angle;
            var bullet = world.createAndAddEntity([
              new Position(tpx, tpy),
              new Velocity(
                  t.bulletVelocity * cos(angle), t.bulletVelocity * sin(angle)),
              new SpriteComponent(t.name),
              new Bullet(bulletTime)
            ]);
            gm.add(bullet, 'bullet');
            t.cooldown = t.maxCooldown;
          }
        });
      }
    });
  }

  @override
  bool checkProcessing() => true;
}

class BulletCollisionSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  Mapper<Enemy> em;
  GroupManager gm;
  BulletCollisionSystem()
      : super(Aspect.getAspectForAllOf([Bullet, BulletCollision]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    entity.deleteFromWorld();
    var enemyEntities = gm.getEntities('enemy');
    enemyEntities.forEach((enemyEntity) {
      var ep = pm[enemyEntity];
      var distX = ep.value.x - p.value.x;
      var distY = ep.value.y - p.value.y;
      if (distX * distX + distY * distY < 900) {
        var enemy = em[enemyEntity];
        enemy.health -= 1.0;
        if (enemy.health <= 0.0) {
          enemyEntity.deleteFromWorld();
        }
      }
    });
  }
}

class TowerCooldownSystem extends EntityProcessingSystem {
  Mapper<Tower> tm;
  TowerCooldownSystem() : super(Aspect.getAspectForAllOf([Tower]));

  @override
  void processEntity(Entity entity) {
    tm[entity].cooldown -= world.delta;
  }
}

class BulletCollisionCountdownSystem extends EntityProcessingSystem {
  Mapper<Bullet> bm;
  BulletCollisionCountdownSystem() : super(Aspect.getAspectForAllOf([Bullet]));

  @override
  void processEntity(Entity entity) {
    var b = bm[entity];
    b.collisionTimer -= world.delta;
    if (b.collisionTimer <= 0.0) {
      entity
        ..addComponent(new BulletCollision())
        ..changedInWorld();
    }
  }
}
