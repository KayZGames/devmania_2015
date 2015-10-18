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
  Mapper<Cooldown> cm;
  GridPositionManager gpManager;
  GroupManager gm;
  EnemyInRangeDetectionSystem()
      : super(Aspect.getAspectForAllOf([Position, Velocity, Enemy]));

  @override
  void processEntities(Iterable<Entity> entities) {
    var towerEntities = gpManager.getTowers();
    towerEntities.forEach((towerEntity) {
      var c = cm[towerEntity];
      if (c.cooldown <= 0.0) {
        var t = tm[towerEntity];
        entities.forEach((entity) {
          var tgp = gpm[towerEntity];
          var p = pm[entity];
          var v = vm[entity];
          var tpx = tgp.x * 32;
          var tpy = tgp.y * 32;
          var distX = p.value.x - tpx;
          var distY = p.value.y - tpy;
          var distanceSquared = distX * distX + distY * distY;
          if (distanceSquared < t.range * t.range) {
            var distance = sqrt(distanceSquared);
            var bulletTime = distance / t.bulletVelocity;
            var angle = atan2(
                distY + v.value.y * bulletTime, distX + v.value.x * bulletTime);
            t.rotation = angle;
            var bullet = world.createAndAddEntity([
              new Position(tpx, tpy),
              new Velocity(
                  t.bulletVelocity * cos(angle), t.bulletVelocity * sin(angle)),
              new SpriteComponent(t.name),
              new Bullet(bulletDamage[t.name]),
              new ExpirationTimer(t.range / t.bulletVelocity)
            ]);
            gm.add(bullet, 'bullet');
            c.cooldown = c.maxCooldown;
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
  Mapper<Bullet> bm;
  GroupManager gm;
  BulletCollisionSystem()
      : super(Aspect.getAspectForAllOf([Bullet]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    bool hasCollision = false;
    var enemyEntities = gm.getEntities('enemy');
    enemyEntities.forEach((enemyEntity) {
      var ep = pm[enemyEntity];
      var distX = ep.value.x - p.value.x;
      var distY = ep.value.y - p.value.y;
      if (distX * distX + distY * distY < 144) {
        hasCollision = true;
        var enemy = em[enemyEntity];
        enemy.health -= bm[entity].damage;
        if (enemy.health <= 0.0) {
          gameState.snowflakes += enemy.worth;
          enemyEntity.deleteFromWorld();
          var maxParticle = 2 + random.nextInt(8);
          for (int i = 0; i < maxParticle; i++) {
            var angle = random.nextDouble() * 2 * PI;
            var velocity = 15.0 + random.nextDouble() * 35.0;
            world.createAndAddEntity([
              new Position(ep.value.x, ep.value.y),
              new Velocity(velocity * cos(angle), velocity * sin(angle)),
              new SpriteComponent('${enemy.name}-explosion'),
              new ExpirationTimer(2.0)
            ]);
          }
        }
      }
    });
    if (hasCollision) {
      entity.deleteFromWorld();
    }
  }
}

class CooldownSystem extends EntityProcessingSystem {
  Mapper<Cooldown> tm;
  CooldownSystem() : super(Aspect.getAspectForAllOf([Cooldown]));

  @override
  void processEntity(Entity entity) {
    tm[entity].cooldown -= world.delta;
  }
}

class ExpirationSystem extends EntityProcessingSystem {
  Mapper<ExpirationTimer> etm;
  ExpirationSystem() : super(Aspect.getAspectForAllOf([ExpirationTimer]));

  @override
  void processEntity(Entity entity) {
    var et = etm[entity];
    et.timer -= world.delta;
    if (et.timer <= 0.0) {
      entity.deleteFromWorld();
    }
  }
}

class FollowsRoadSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  Mapper<Velocity> vm;
  GridPositionManager gpm;
  FollowsRoadSystem() : super(Aspect.getAspectForAllOf([Position, Velocity, FollowsRoad]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    var v = vm[entity];

    var gridX = p.value.x ~/ 32;
    var gridY = p.value.y ~/ 32;
    if (!gpm.roadrMap[gridX + v.value.x.sign.toInt()][gridY + v.value.y.sign.toInt()] && p.value.x % 32 < 1 && p.value.y % 32 < 1) {
      p.value.x = gridX * 32.0;
      p.value.y = gridY * 32.0;
      if (v.value.x == 0.0) {
        if (gpm.roadrMap[gridX + 1][gridY]) {
          v.value.x = v.value.y.abs();
          v.value.y = 0.0;
        } else if (gpm.roadrMap[gridX - 1][gridY]) {
          v.value.x = -v.value.y.abs();
          v.value.y = 0.0;
        } else {
          v.value.y = -v.value.y;
        }
      } else if (v.value.y == 0.0) {
        if (gpm.roadrMap[gridX][gridY + 1]) {
          v.value.y = v.value.x.abs();
          v.value.x = 0.0;
        } else if (gpm.roadrMap[gridX][gridY - 1]) {
          v.value.y = -v.value.x.abs();
          v.value.x = 0.0;
        } else {
          v.value.x = -v.value.x;
        }

      }
    }

  }
}
