part of client;

class MouseInputSystem extends EntityProcessingSystem {
  Mapper<GridPosition> gpm;
  Mapper<Position> pm;
  Mapper<SelectedTower> stm;
  Mapper<Inventory> im;
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
      if (gp.y == 18 &&
          gp.x >= firstTowerSlotX &&
          gp.x < firstTowerSlotX + towers.length) {
        entity
          ..addComponent(new SelectedTower(towers[gp.x - firstTowerSlotX]))
          ..changedInWorld();
      } else if (stm.has(entity) && gpManager.canPlaceTower(gp.x, gp.y)) {
        var name = stm[entity].name;
        if (towerCosts[name] <= gameState.snowflakes) {
          world.createAndAddEntity([
            new GridPosition(gp.x, gp.y),
            new SpriteComponent('gun-$name'),
            new Tower(name),
            new Cooldown(towerCooldowns[name])
          ]);
          gameState.snowflakes -= towerCosts[name];
        }
      } else if (gpManager.towerMap[gp.x][gp.y] != null) {
        entity
          ..removeComponent(SelectedTower)
          ..changedInWorld();
        var towerEntity = gpManager.towerMap[gp.x][gp.y];
        towerEntity
          ..addComponent(new UpgradeMenu())
          ..changedInWorld();
        // no, don't do this
        world.processEntityChanges();
      } else {
        entity
          ..removeComponent(SelectedTower)
          ..changedInWorld();
        // no, don't do this
        world.processEntityChanges();
      }
      clicked = false;
    }
  }

  @override
  bool checkProcessing() => !gameState.gameOver;
}

class KeyboardInputSystem extends GenericInputHandlingSystem {
  Mapper<Tower> tm;
  KeyboardInputSystem() : super(Aspect.getAspectForAllOf([UpgradeMenu, Tower]));

  @override
  void processEntity(Entity entity) {
    if (isPressed(KeyCode.ESC)) {
      entity
        ..removeComponent(UpgradeMenu)
        ..changedInWorld();
    }
    var t = tm[entity];
    if (isPressed(KeyCode.ONE) || isPressed(KeyCode.NUM_ONE)) {
      unpress[KeyCode.ONE] = true;
      unpress[KeyCode.NUM_ONE] = true;
      if (t.rangeUpgradeCost <= gameState.snowflakes) {
        gameState.snowflakes -= t.rangeUpgradeCost;
        t.rangeLevel++;
      }
    } else if (isPressed(KeyCode.TWO) || isPressed(KeyCode.NUM_TWO)) {
      unpress[KeyCode.TWO] = true;
      unpress[KeyCode.NUM_TWO] = true;
      if (t.bulletVelocityUpgradeCost <= gameState.snowflakes) {
        gameState.snowflakes -= t.bulletVelocityUpgradeCost;
        t.bulletVelocityLevel++;
      }
    } else if (isPressed(KeyCode.THREE) || isPressed(KeyCode.NUM_THREE)) {
      unpress[KeyCode.THREE] = true;
      unpress[KeyCode.NUM_THREE] = true;
      if (t.bulletDamageUpgradeCost <= gameState.snowflakes) {
        gameState.snowflakes -= t.bulletDamageUpgradeCost;
        t.bulletDamageLevel++;
      }
    } else if (isPressed(KeyCode.FOUR) || isPressed(KeyCode.NUM_FOUR)) {
      unpress[KeyCode.FOUR] = true;
      unpress[KeyCode.NUM_FOUR] = true;
      if (t.cooldownUpgradeCost <= gameState.snowflakes) {
        gameState.snowflakes -= t.cooldownUpgradeCost;
        t.cooldownLevel++;
      }
    }
  }
}
