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
const Map<String, double> bulletVelocities = const {'pellet': 100, 'fireball': 50};
const Map<String, double> enemyHealth = const {'snowman': 10.0};
const int firstTowerSlotX = 14;