part of shared;

class EnemySpawner extends IntervalEntitySystem {
  GroupManager gm;
  EnemySpawner() : super(5.0, Aspect.getEmpty());

  @override
  void processEntities(Iterable<Entity> entities) {
    var enemy = world.createAndAddEntity([new Position(-16, 300), new Velocity(20, 0), new SpriteComponent('snowman'), new Enemy('snowman')]);
    gm.add(enemy, 'enemy');
  }
}