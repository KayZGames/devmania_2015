part of client;

class SpriteRenderingSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  Mapper<SpriteComponent> sm;

  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  SpriteRenderingSystem(this.ctx, this.sheet)
      : super(Aspect.getAspectForAllOf([Position, SpriteComponent])
            .exclude([GridPosition]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    var s = sm[entity].name;
    var sprite = sheet[s];

    ctx
      ..save()
      ..translate(p.value.x, p.value.y)
      ..drawImageScaledFromSource(
          sheet.image,
          sprite.src.left,
          sprite.src.top,
          sprite.src.width,
          sprite.src.height,
          -sprite.src.width / 2,
          -sprite.src.height / 2,
          sprite.src.width,
          sprite.src.height)
      ..restore();
  }
}

abstract class GridPositionRenderingSystem extends EntityProcessingSystem {
  Mapper<GridPosition> gpm;
  Mapper<SpriteComponent> sm;

  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  GridPositionRenderingSystem(this.ctx, this.sheet, Aspect aspect)
      : super(aspect.allOf([GridPosition, SpriteComponent]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var s = sm[entity].name;
    drawOnGrid(gp, s);
  }

  void drawOnGrid(GridPosition gp, String name,
      [double rotation = 0.0, double alpha = 1.0]) {
    var sprite = sheet[name];
    ctx
      ..save()
      ..globalAlpha = alpha
      ..translate(gp.x * 32, gp.y * 32)
      ..rotate(rotation)
      ..drawImageScaledFromSource(
          sheet.image,
          sprite.src.left,
          sprite.src.top,
          sprite.src.width,
          sprite.src.height,
          -sprite.src.width / 2,
          -sprite.src.height / 2,
          sprite.src.width,
          sprite.src.height)
      ..restore();
  }
}

class CursorRenderingSystem extends GridPositionRenderingSystem {
  CursorRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([Cursor]));
}

class TileRenderingSystem extends GridPositionRenderingSystem {
  TileRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([Tile]));
}

class TowerRenderingSystem extends GridPositionRenderingSystem {
  Mapper<Tower> tm;
  TowerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([Tower]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var t = tm[entity];
    drawOnGrid(gp, 'towerbase');
    drawOnGrid(gp, 'gun-${t.name}', t.rotation);
  }
}

class SelectedTowerRenderingSystem extends GridPositionRenderingSystem {
  Mapper<SelectedTower> stm;
  SelectedTowerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([SelectedTower]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var st = stm[entity];
    ctx
      ..save()
      ..strokeStyle = 'red'
      ..fillStyle = 'red'
      ..lineWidth = 1
      ..beginPath()
      ..arc(gp.x * 32, gp.y * 32, towerRanges[st.name], 0, 2 * PI)
      ..closePath()
      ..globalAlpha = 0.4
      ..stroke()
      ..globalAlpha = 0.05
      ..fill()
      ..restore();
    drawOnGrid(gp, 'towerbase', 0.0, 0.3);
    drawOnGrid(gp, 'gun-${st.name}', 0.0, 0.3);
  }
}

class EnemyHealtRenderingSystem extends EntityProcessingSystem {
  Mapper<Enemy> em;
  Mapper<Position> pm;

  CanvasRenderingContext2D ctx;
  EnemyHealtRenderingSystem(this.ctx)
      : super(Aspect.getAspectForAllOf([Enemy, Position]));

  @override
  void processEntity(Entity entity) {
    var e = em[entity];
    var p = pm[entity];

    ctx
      ..save()
      ..strokeStyle = 'black'
      ..fillStyle = 'green'
      ..strokeRect(p.value.x - 16, p.value.y - 24, 32, 6)
      ..fillRect(p.value.x - 16, p.value.y - 24, 32 * e.health / e.maxHealth, 6)
      ..restore();
  }
}

class GameStateRenderingSystem extends VoidEntitySystem {
  static const String label = 'Snowflakes: ';
  CanvasRenderingContext2D ctx;
  GameStateRenderingSystem(this.ctx);

  @override
  void processSystem() {
    var snowflakes = gameState.snowflakes;

    ctx
      ..save()
      ..font = '16px Verdana'
      ..lineWidth = 1
      ..strokeStyle = 'black'
      ..fillStyle = '#6ba3ff';

    var valueWidth = ctx.measureText('$snowflakes').width;
    ctx
      ..strokeText(label, 750, 0)
      ..fillText(label, 750, 0)
      ..strokeText('$snowflakes', 920 - valueWidth, 0)
      ..fillText('$snowflakes', 920 - valueWidth, 0)
      ..restore();
  }
}
