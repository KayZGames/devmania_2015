library shared;

import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
part 'src/shared/components.dart';
//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';
part 'src/shared/systems/managers.dart';
part 'src/shared/systems/spawner.dart';

const List<String> towers = const ['pellet', 'fireball', 'flamethrower'];
const Map<String, int> towerRanges = const {
  'pellet': 100,
  'fireball': 75,
  'flamethrower': 50
};
const Map<String, double> towerCooldowns = const {
  'pellet': 1.0,
  'fireball': 2.0,
  'flamethrower': 0.2,
};
const Map<String, int> towerCosts = const {
  'pellet': 50,
  'fireball': 75,
  'flamethrower': 100
};
const Map<String, int> bulletDamage = const {
  'pellet': 1,
  'fireball': 5,
  'flamethrower': 1
};
const Map<String, double> bulletVelocities = const {
  'pellet': 100,
  'fireball': 50,
  'flamethrower': 25,
};
const Map<String, double> enemyHealth = const {'snowman': 6.0};
const Map<String, int> enemyWorth = const {'snowman': 10};
const int firstTowerSlotX = 14;
List<List<int>> road = [
  [0, 10],
  [1, 10],
  [2, 10],
  [3, 10],
  [4, 10],
  [5, 10],
  [6, 10],
  [7, 10],
  [8, 10],
  [9, 10],
  [10, 10],
  [11, 10],
  [12, 10],
  [13, 10],
  [14, 10],
  [15, 10],
  [16, 10],
  [17, 10],
  [18, 10],
  [19, 10],
  [20, 10],
  [20, 11],
  [20, 12],
  [20, 13],
  [20, 14],
  [20, 15],
  [19, 15],
  [18, 15],
  [17, 15],
  [16, 15],
  [15, 15],
  [14, 15],
  [13, 15],
  [13, 14],
  [13, 13],
  [13, 12],
  [13, 11],
  [13, 10],
  [13, 9],
  [13, 8],
  [13, 7],
  [12, 7],
  [11, 7],
  [10, 7]
];

final GameState gameState = new GameState();

class GameState {
  int snowflakes = 50;
  int kills = 0;
}
