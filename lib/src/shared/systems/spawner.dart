part of shared;

class EnemySpawner extends VoidEntitySystem {
  num _acc = 0;
  num _interval = 5.0;

  GroupManager gm;

  bool checkProcessing() {
    _acc += world.delta;
    if (_acc >= _interval) {
      _acc -= _interval;
      return true;
    }
    return false;
  }

  @override
  void processSystem() {
    var killMod = 1 + (gameState.kills ~/ 10) / 5;
    _interval = 5.0 / killMod;
    var enemy = world.createAndAddEntity([new Position(-32, 320), new Velocity(200 * killMod, 0), new SpriteComponent('snowman'), new Enemy('snowman', killMod), new FollowsRoad()]);
    gm.add(enemy, 'enemy');
  }
}