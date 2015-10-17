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

  Game() : super('devmania_2015', '#game', 800, 600, bodyDefsName: null);

  void createEntities() {
    addEntity([new Position(0, 0), new Velocity(10, 10), new SpriteComponent('snowman')]);
    addEntity([new Position(0, 0), new Velocity(10, 10), new SpriteComponent('cursor'), new Cursor(), new GridPosition(0, 0)]);
  }
  Map<int, List<EntitySystem>> getSystems() {
    return {
      GameBase.rendering: [
        new MouseInputSystem(canvas),
        new CanvasCleaningSystem(canvas, fillStyle: 'black'),
        new SnowflakeRenderingSystem(ctx),
        new SpriteRenderingSystem(ctx, spriteSheet),
        new GridPositionRenderingSystem(ctx, spriteSheet),
        new FpsRenderingSystem(ctx, fillStyle: 'white'),
      ],
      GameBase.physics: [
        new MovementSystem(),
        new SnowflakeMovementSystem(),
      ]
    };
  }
}

