library client;

import 'dart:html';
export 'dart:html';
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

    addEntity([
      new Position(300, 224),
      new Velocity(0, 0),
      new SpriteComponent('santa'),
    ]);
    var enemy = addEntity([
      new Position(-32, 320),
      new Velocity(20, 0),
      new SpriteComponent('snowman'),
      new Enemy('snowman', 1.0),
      new FollowsRoad()
    ]);
    gm.add(enemy, 'enemy');

    addEntity([
      new Position(0, 0),
      new Velocity(10, 10),
      new SpriteComponent('cursor'),
      new Cursor(),
      new GridPosition(0, 0)
    ]);

    for (int x = 0; x < 30; x++) {
      for (int y = 0; y < 20; y++) {
        addEntity([
          new GridPosition(x, y),
          new SpriteComponent('snowtile'),
          new Tile()
        ]);
      }
    }
    road.forEach((value) => addEntity([
          new GridPosition(value[0], value[1]),
          new SpriteComponent('roadtile'),
          new Tile(),
          new Road(),
          new BlocksTower()
        ]));
    var slotX = firstTowerSlotX;
    towers.forEach((name) {
      addEntity([
        new GridPosition(slotX, 18),
        new SpriteComponent('towerslot'),
        new Tile()
      ]);
      addEntity([
        new GridPosition(slotX, 18),
        new SpriteComponent('gun-$name'),
        new Tower(name),
        new Inventory(towerCosts[name])
      ]);
      slotX++;
    });
  }

  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new MouseInputSystem(canvas),
        new KeyboardInputSystem(),
        new MovementSystem(),
        new FollowsRoadSystem(),
        new CanvasCleaningSystem(canvas, fillStyle: 'black'),
        new TileRenderingSystem(ctx, spriteSheet),
        new SpriteRenderingSystem(ctx, spriteSheet),
        new TowerRenderingSystem(ctx, spriteSheet),
        new SelectedTowerRenderingSystem(ctx, spriteSheet),
        new CursorRenderingSystem(ctx, spriteSheet),
        new InventoryRenderingSystem(ctx, spriteSheet),
        new EnemyHealtRenderingSystem(ctx),
        new TowerUpgradMenuRenderingSystem(ctx),
        new GameStateRenderingSystem(ctx),
        new GameOverRenderingSystem(ctx),
//        new FpsRenderingSystem(ctx, fillStyle: 'black'),
        new EnemyInRangeDetectionSystem(),
        new CooldownSystem(),
        new EnemySpawner(),
        new BulletCollisionSystem(),
        new ExpirationSystem(),
        new StolenPresentSystem(),
      ]
    };
  }

  onInit() {
    world.addManager(new GridPositionManager());
    world.addManager(new GroupManager());
    world.addManager(new TagManager());
  }
}
