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
  Mapper<GridPosition> gpm;
  Mapper<Tower> tm;
  GridPositionManager gpManager;
  EnemyInRangeDetectionSystem() : super(Aspect.getAspectForAllOf([Position, Enemy]));

  @override
  void processEntities(Iterable<Entity> entities) {
    var towerEntities = gpManager.getTowers();
    towerEntities.forEach((towerEntity) {
      var t = tm[towerEntity];
      if (t.cooldown <= 0.0) {
        entities.forEach((entity) {
          var tgp = gpm[towerEntity];
          var p = pm[entity];
          var tpx = tgp.x * 32;
          var tpy = tgp.y * 32;
          var distX = p.value.x + 16 - tpx;
          var distY = p.value.y + 16 - tpy;
          if (distX * distX + distY * distY < t.range * t.range) {
            var angle = atan2(distY, distX);
            world.createAndAddEntity([new Position(tpx, tpy), new Velocity(t.bulletVelocity * cos(angle), t.bulletVelocity * sin(angle)), new SpriteComponent(t.name)]);
            t.cooldown = t.maxCooldown;
          }
        });
      }
    });
  }

  @override
  bool checkProcessing() => true;
}

class TowerCooldownSystem extends EntityProcessingSystem {
  Mapper<Tower> tm;
  TowerCooldownSystem() : super(Aspect.getAspectForAllOf([Tower]));

  @override
  void processEntity(Entity entity) {
    tm[entity].cooldown -= world.delta;
  }
}
