import 'package:flame/extensions.dart';

extension Vector2Extension on Vector2 {
  Vector2 toSquare() => (this / 64)..floor();
  Rect toRect64() => Rect.fromPoints(
      (this * 64).toOffset(), ((this + Vector2(1, 1)) * 64).toOffset());
}
