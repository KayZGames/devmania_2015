library client;

import 'dart:html' hide Player, Timeline;
export 'dart:html' hide Player, Timeline;
import 'package:devmania_2015/shared.dart';
import 'package:gamedev_helpers/gamedev_helpers.dart';
export 'package:gamedev_helpers/gamedev_helpers.dart';
//part 'src/client/systems/name.dart';
part 'src/client/systems/events.dart';
part 'src/client/systems/rendering.dart';

class Game extends GameBase {

  Game() : super('devmania_2015', '#game', 960, 640, bodyDefsName: null) {
    canvas.context2D.translate(16, 16);
  }

  void createEntities() {
    var gm = world.getManager(GroupManager) as GroupManager;

    var enemy = addEntity([new Position(-16, 300), new Velocity(20, 0), new SpriteComponent('snowman'), new Enemy('snowman')]);
    gm.add(enemy, 'enemy');

    addEntity([new Position(0, 0), new Velocity(10, 10), new SpriteComponent('cursor'), new Cursor(), new GridPosition(0, 0)]);
    for (int x = 0; x < 30; x++) {
      for (int y = 0; y < 20; y++) {
        addEntity([new GridPosition(x, y), new SpriteComponent('snowtile'), new Tile()]);
      }
    }
    for (int x = 0; x < 30; x++) {
      addEntity([new GridPosition(x, 10), new SpriteComponent('roadtile'), new Tile(), new BlocksTower()]);
    }
    var slotX = firstTowerSlotX;
    towers.forEach((name) {
      addEntity([new GridPosition(slotX, 19), new SpriteComponent('towerslot'), new Tile()]);
      addEntity([new GridPosition(slotX, 19), new SpriteComponent('gun-$name'), new Tower(name)]);
      slotX++;
    });

  }
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new MouseInputSystem(canvas),
        new CanvasCleaningSystem(canvas, fillStyle: 'black'),
        new SnowflakeRenderingSystem(ctx),

        new TileRenderingSystem(ctx, spriteSheet),
        new SpriteRenderingSystem(ctx, spriteSheet),
        new TowerRenderingSystem(ctx, spriteSheet),
        new SelectedTowerRenderingSystem(ctx, spriteSheet),
        new CursorRenderingSystem(ctx, spriteSheet),
        new EnemyHealtRenderingSystem(ctx),

        new FpsRenderingSystem(ctx, fillStyle: 'black'),
      ],
      GameBase.physics: [
        new MovementSystem(),
        new EnemyInRangeDetectionSystem(),
        new TowerCooldownSystem(),
        new BulletCollisionCountdownSystem(),
        new EnemySpawner(),
        new BulletCollisionSystem(),
      ]
    };
  }

  onInit() {
    world.addManager(new GridPositionManager());
    world.addManager(new GroupManager());
  }


}

