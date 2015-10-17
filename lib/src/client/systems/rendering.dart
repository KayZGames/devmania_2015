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
      : super(Aspect.getAspectForAllOf([Position, SpriteComponent]));

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
