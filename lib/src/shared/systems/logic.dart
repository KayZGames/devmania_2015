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
              new Bullet(bulletTime / 2),
              new ExpirationTimer(10.0)
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
      : super(Aspect.getAspectForAllOf([Bullet, BulletCollisionCheck]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    bool hasCollision = false;
    var enemyEntities = gm.getEntities('enemy');
    enemyEntities.forEach((enemyEntity) {
      var ep = pm[enemyEntity];
      var distX = ep.value.x - p.value.x;
      var distY = ep.value.y - p.value.y;
      if (distX * distX + distY * distY < 576) {
        hasCollision = true;
        var enemy = em[enemyEntity];
        enemy.health -= 1.0;
        if (enemy.health <= 0.0) {
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
    } else {
      entity
        ..removeComponent(BulletCollisionCheck)
        ..changedInWorld();
    }
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

class BulletCollisionCountdownSystem extends EntityProcessingSystem {
  Mapper<Bullet> bm;
  BulletCollisionCountdownSystem() : super(Aspect.getAspectForAllOf([Bullet]));

  @override
  void processEntity(Entity entity) {
    var b = bm[entity];
    b.collisionTimer -= world.delta;
    if (b.collisionTimer <= 0.0) {
      b.collisionTimer = b.maxTime / 2;
      entity
        ..addComponent(new BulletCollisionCheck(b.maxTime))
        ..changedInWorld();
    }
  }
}
