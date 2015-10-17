part of client;


class MouseInputSystem extends EntityProcessingSystem {
  Mapper<GridPosition> gpm;
  Mapper<Position> pm;

  Point<int> offset = new Point<int>(0, 0);
  CanvasElement canvas;

  MouseInputSystem(this.canvas) : super(Aspect.getAspectForAllOf([GridPosition, Cursor]));

  @override
  void initialize() {
    canvas.onMouseMove.listen((event) => offset = event.offset);
  }

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var p = pm[entity];

    gp.x = offset.x ~/ 32;
    gp.y = offset.y ~/ 32;

    p.value = new Vector2(offset.x.toDouble(), offset.y.toDouble());
  }
}