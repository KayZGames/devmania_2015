part of shared;


class GridPositionManager extends Manager {
  Mapper<Tower> tm;
  Mapper<Inventory> im;
  Mapper<BlocksTower> btm;
  Mapper<GridPosition> gpm;
  Mapper<Road> rm;
  GroupManager gm;

  List<List<Entity>> towerMap = new List.generate(30, (_) => new List.generate(20, (_) => null));
  List<List<bool>> towerBlockerMap = new List.generate(30, (_) => new List.generate(20, (_) => false));
  List<List<bool>> roadrMap = new List.generate(30, (_) => new List.generate(20, (_) => false));

  void added(Entity e) {
    if (tm.has(e) && !im.has(e)) {
      var gp = gpm[e];
      towerMap[gp.x][gp.y] = e;
      gm.add(e, 'tower');
    }
    if (btm.has(e)) {
      var gp = gpm[e];
      towerBlockerMap[gp.x][gp.y] = true;
    }
    if (rm.has(e)) {
      var gp = gpm[e];
      roadrMap[gp.x][gp.y] = true;
    }
  }

  bool canPlaceTower(int x, int y) => towerMap[x][y] == null && !towerBlockerMap[x][y];

  Iterable<Entity> getTowers() => gm.getEntities('tower');

}