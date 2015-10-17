part of client;

class MouseInputSystem extends EntityProcessingSystem {
  Mapper<GridPosition> gpm;
  Mapper<Position> pm;
  Mapper<SelectedTower> stm;
  GridPositionManager gpManager;

  Point<int> offset = new Point<int>(0, 0);
  bool clicked = false;
  CanvasElement canvas;

  MouseInputSystem(this.canvas)
      : super(Aspect.getAspectForAllOf([GridPosition, Cursor]));

  @override
  void initialize() {
    canvas.onMouseMove.listen((event) => offset = event.offset);
    canvas.onClick.listen((event) => clicked = true);
  }

  @override
  void processEntity(Entity entity) {
    var gp = gpm[entity];
    var p = pm[entity];

    gp.x = offset.x ~/ 32;
    gp.y = offset.y ~/ 32;

    p.value = new Vector2(offset.x.toDouble(), offset.y.toDouble());

    if (clicked) {
      if (clicked) {
        if (gp.y == 19 &&
            gp.x >= firstTowerSlotX &&
            gp.x < firstTowerSlotX + towers.length) {
          entity
            ..addComponent(new SelectedTower(towers[gp.x - firstTowerSlotX]))
            ..changedInWorld();
        } else if (stm.has(entity) && gpManager.canPlaceTower(gp.x, gp.y)) {
          var name = stm[entity].name;
          world.createAndAddEntity([new GridPosition(gp.x, gp.y), new SpriteComponent('gun-$name'), new Tower(name)]);
        }
      }
      clicked = false;
    }
  }
}
