import 'package:adventures_in_2d_games/enums/direction.dart';
import 'package:adventures_in_2d_games/utilities/constants.dart';
import 'package:flame/extensions.dart';

class MovementVector {
  static get up => Vector2(0, -squareSize);
  static get down => Vector2(0, squareSize);
  static get left => Vector2(-squareSize, 0);
  static get right => Vector2(squareSize, 0);

  static final _map = <Direction, Vector2>{
    Direction.up: MovementVector.up,
    Direction.down: MovementVector.down,
    Direction.left: MovementVector.left,
    Direction.right: MovementVector.right
  };

  static Vector2 toward(Direction direction) =>
      _map[direction] ?? Vector2(0, 0);
}
