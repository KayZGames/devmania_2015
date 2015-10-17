part of client;

class SnowflakeRenderingSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  CanvasRenderingContext2D ctx;

  SnowflakeRenderingSystem(this.ctx)
      : super(Aspect.getAspectForAllOf([Position]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];

    ctx
      ..save()
      ..fillStyle = 'white'
      ..fillRect(p.value.x, p.value.y, 1, 1)
      ..restore();
  }
}

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
      ..drawImageScaledFromSource(
          sheet.image,
          sprite.src.left,
          sprite.src.top,
          sprite.src.width,
          sprite.src.height,
          p.value.x,
          p.value.y,
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

  void drawOnGrid(GridPosition gp, String name, [double alpha = 1.0]) {
    var sprite = sheet[name];
    ctx
      ..save()
      ..globalAlpha = alpha
      ..drawImageScaledFromSource(
          sheet.image,
          sprite.src.left,
          sprite.src.top,
          sprite.src.width,
          sprite.src.height,
          gp.x * 32 + sprite.dst.left,
          gp.y * 32 + sprite.dst.top,
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
  TowerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([Tower]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    drawOnGrid(gp, 'towerbase');
    super.processEntity(entity);
  }
}

class SelectedTowerRenderingSystem extends GridPositionRenderingSystem {
  Mapper<SelectedTower> stm;
  SelectedTowerRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([SelectedTower]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    drawOnGrid(gp, 'towerbase', 0.3);
    drawOnGrid(gp, 'gun-${stm[entity].name}', 0.3);
  }
}
