part of shared;


class GridPositionManager extends Manager {
  Mapper<Tower> tm;
  Mapper<BlocksTower> btm;
  Mapper<GridPosition> gpm;

  List<List<bool>> towerMap = new List.generate(30, (_) => new List.generate(20, (_) => false));
  List<List<bool>> towerBlockerMap = new List.generate(30, (_) => new List.generate(20, (_) => false));

  void added(Entity e) {
    if (tm.has(e)) {
      var gp = gpm[e];
      towerMap[gp.x][gp.y] = true;
    } else if (btm.has(e)) {
      var gp = gpm[e];
      towerBlockerMap[gp.x][gp.y] = true;
    }
  }

  bool canPlaceTower(int x, int y) => !towerMap[x][y] && !towerBlockerMap[x][y];
}