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

class SnowflakeMovementSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  SnowflakeMovementSystem() : super(Aspect.getAspectForAllOf([Position, Snowflake]));

  @override
  void processEntity(Entity entity) {
    // TODO: implement processEntity
  }
}
