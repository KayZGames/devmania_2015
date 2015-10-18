part of shared;

class EnemySpawner extends IntervalEntitySystem {
  GroupManager gm;
  EnemySpawner() : super(5.0, Aspect.getEmpty());

  @override
  void processEntities(Iterable<Entity> entities) {
    var enemy = world.createAndAddEntity([new Position(-32, 320), new Velocity(20, 0), new SpriteComponent('snowman'), new Enemy('snowman'), new FollowsRoad()]);
    gm.add(enemy, 'enemy');
  }
}