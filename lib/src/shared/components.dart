part of shared;

class Position extends Component {
  Vector2 value;
  Position(num x, num y) : value = new Vector2(x.toDouble(), y.toDouble());
}

class GridPosition extends Component {
  int x, y;
  GridPosition(this.x, this.y);
}

class Velocity extends Component {
  Vector2 value;
  Velocity(num x, num y) : value = new Vector2(x.toDouble(), y.toDouble());
}

class SpriteComponent extends Component {
  String name;
  SpriteComponent(this.name);
}

class Snowflake extends Component {}

class Cursor extends Component {}