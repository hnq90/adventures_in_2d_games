import 'package:adventures_in_2d_games/enums/direction.dart';
import 'package:adventures_in_2d_games/utilities/movement_vector.dart';
import 'package:flame/extensions.dart';

extension DirectionExtension on Direction? {
  Vector2 get vector => MovementVector.toward(this ?? Direction.up);
}
