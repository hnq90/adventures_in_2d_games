import 'package:flame/extensions.dart';

enum Direction { up, down, left, right }

final _movementIn = <Direction, Vector2>{
  Direction.up: Vector2(0, -64),
  Direction.down: Vector2(0, 64),
  Direction.left: Vector2(-64, 0),
  Direction.right: Vector2(64, 0)
};

extension DirectionExtension on Direction? {
  Vector2 get vector => _movementIn[this] ?? Vector2(0, 0);
}
