library shared;
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
part 'src/shared/components.dart';
//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';
part 'src/shared/systems/managers.dart';
part 'src/shared/systems/spawner.dart';


const List<String> towers = const ['pellet', 'fireball', 'pellet'];
const Map<String, int> towerRanges = const {'pellet': 100, 'fireball': 50};
const Map<String, double> towerCooldowns = const {'pellet': 0.1, 'fireball': 0.5};
const Map<String, int> towerCosts = const {'pellet': 50, 'fireball': 75};
const Map<String, int> bulletDamage = const {'pellet': 1, 'fireball': 5};
const Map<String, double> bulletVelocities = const {'pellet': 100, 'fireball': 50};
const Map<String, double> enemyHealth = const {'snowman': 100.0};
const Map<String, int> enemyWorth = const {'snowman': 10};
const int firstTowerSlotX = 14;

final GameState gameState = new GameState();

class GameState {
  int snowflakes = 100;
}