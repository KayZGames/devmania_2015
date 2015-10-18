part of client;

class SpriteRenderingSystem extends EntityProcessingSystem {
  Mapper<Position> pm;
  Mapper<Velocity> vm;
  Mapper<SpriteComponent> sm;

  CanvasRenderingContext2D ctx;
  SpriteSheet sheet;
  SpriteRenderingSystem(this.ctx, this.sheet)
      : super(Aspect.getAspectForAllOf([Position, Velocity, SpriteComponent])
            .exclude([GridPosition]));

  @override
  void processEntity(Entity entity) {
    var p = pm[entity];
    var v = vm[entity];
    var s = sm[entity].name;
    var sprite = sheet[s];
    if (null == sprite) {
      print(entity);
      print(s);
    }

    ctx
      ..save()
      ..translate(p.value.x, p.value.y)
      ..rotate(atan2(v.value.y, v.value.x))
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
    if (towerCosts[st.name] > gameState.snowflakes) {
      drawOnGrid(gp, 'unaffordable');
    }
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
  static const String labelSnowflakes = 'Snowflakes: ';
  static const String labelSnowmen = 'Dead Snowmen: ';
  static const String labelRemaining = 'Remaining Presents: ';
  static const String labelStolen = 'Stolen Presents: ';
  CanvasRenderingContext2D ctx;
  GameStateRenderingSystem(this.ctx);

  @override
  void processSystem() {
    var snowflakes = gameState.snowflakes;
    var kills = gameState.kills;
    var presents = gameState.presents;
    var stolen = 10 - gameState.presents;

    ctx
      ..save()
      ..font = '16px Verdana'
      ..lineWidth = 1
      ..strokeStyle = 'black'
      ..fillStyle = '#6ba3ff';

    var valueWidth = ctx.measureText('$snowflakes').width;
    var snowmenWidth = ctx.measureText('$kills').width;
    var presentsWidth = ctx.measureText('$presents').width;
    var stolenWidth = ctx.measureText('$stolen').width;
    var labelSnowmenWidth = ctx.measureText(labelSnowmen).width;
    var labelSnowflakesWidth = ctx.measureText(labelSnowflakes).width;
    var labelRemainingWidth = ctx.measureText(labelRemaining).width;
    var labelStolenWidth = ctx.measureText(labelStolen).width;
    ctx
      ..strokeText(labelSnowflakes, 850 - labelSnowflakesWidth, 0)
      ..fillText(labelSnowflakes, 850 - labelSnowflakesWidth, 0)
      ..strokeText(labelSnowmen, 850 - labelSnowmenWidth, 20)
      ..fillText(labelSnowmen, 850 - labelSnowmenWidth, 20)
      ..strokeText(labelStolen, 850 - labelStolenWidth, 40)
      ..fillText(labelStolen, 850 - labelStolenWidth, 40)
      ..strokeText(labelRemaining, 850 - labelRemainingWidth, 60)
      ..fillText(labelRemaining, 850 - labelRemainingWidth, 60)
      ..strokeText('$snowflakes', 920 - valueWidth, 0)
      ..fillText('$snowflakes', 920 - valueWidth, 0)
      ..strokeText('$kills', 920 - snowmenWidth, 20)
      ..fillText('$kills', 920 - snowmenWidth, 20)
      ..strokeText('$stolen', 920 - stolenWidth, 40)
      ..fillText('$stolen', 920 - stolenWidth, 40)
      ..strokeText('$presents', 920 - presentsWidth, 60)
      ..fillText('$presents', 920 - presentsWidth, 60)
      ..restore();
  }
}

class InventoryRenderingSystem extends GridPositionRenderingSystem {
  Mapper<Inventory> im;
  InventoryRenderingSystem(CanvasRenderingContext2D ctx, SpriteSheet sheet)
      : super(ctx, sheet, Aspect.getAspectForAllOf([GridPosition, Inventory]));

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var i = im[entity];
    ctx
      ..save()
      ..font = '14px Verdana'
      ..lineWidth = 1
      ..strokeStyle = 'black'
      ..fillStyle = '#6ba3ff';

    var width = ctx.measureText('${i.cost}').width;

    ctx
      ..strokeText('${i.cost}', gp.x * 32 - width / 2, gp.y * 32 + 16)
      ..fillText('${i.cost}', gp.x * 32 - width / 2, gp.y * 32 + 16)
      ..restore();
    if (i.cost > gameState.snowflakes) {
      drawOnGrid(gp, 'unaffordable');
    }
  }
}

class GameOverRenderingSystem extends VoidEntitySystem {
  static const String gameOver = 'GAME OVER';
  CanvasRenderingContext2D ctx;
  GameOverRenderingSystem(this.ctx);

  @override
  void processSystem() {
    ctx
      ..save()
      ..font = '96px Verdana'
      ..lineWidth = 1
      ..strokeStyle = 'black'
      ..fillStyle = '#44447d';

    var width = ctx.measureText(gameOver).width;

    ctx
      ..strokeText(gameOver, 480 - width / 2, 272)
      ..fillText(gameOver, 480 - width / 2, 272)
      ..restore();
  }

  @override
  bool checkProcessing() => gameState.gameOver;
}
