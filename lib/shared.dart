library shared;
import 'package:gamedev_helpers/gamedev_helpers_shared.dart';
part 'src/shared/components.dart';
//part 'src/shared/systems/name.dart';
part 'src/shared/systems/logic.dart';
part 'src/shared/systems/managers.dart';


const List<String> towers = const ['pellet', 'pellet', 'pellet'];
const Map<String, int> towerRanges = const {'pellet': 100};
const Map<String, double> towerCooldowns = const {'pellet': 0.1};
const Map<String, double> bulletVelocities = const {'pellet': 100};
const int firstTowerSlotX = 14;