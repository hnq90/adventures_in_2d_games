import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart' as game;

typedef StartPos = Map<Direction, double>;
enum Direction { up, down, left, right }

extension DirectionExtension on Direction {
  Direction getNext() =>
      Direction.values[(index + 1) % Direction.values.length];
}

const StartPos startPosFor = {
  Direction.up: 192,
  Direction.down: 96,
  Direction.left: 0,
  Direction.right: 288
};

class Character {
  // Private constructor.
  Character._(Map<Direction, SpriteAnimation> animationFor,
      {Vector2? position, Vector2? size})
      : _position = position ?? Vector2(240, 50),
        _size = size ?? Vector2(60, 60) {
    _area = _position & _size;
    _animationFor = animationFor;
    _currentAnimation = animationFor[_currentDirection]!;
  }

  ////////////////// start static section ///////////////////////

  // Static async create method so we can load sprite animations.
  static Future<Character> createAsync(String path) async {
    final mapOfAnimations = <Direction, SpriteAnimation>{};

    for (var direction in Direction.values) {
      mapOfAnimations[direction] = await SpriteAnimation.load(
          path,
          SpriteAnimationData.sequenced(
              amount: 3,
              textureSize: Vector2(32, 32),
              stepTime: 0.1,
              texturePosition: Vector2(startPosFor[direction]!, 0)));
    }

    return Character._(mapOfAnimations);
  }

  ////////////////// end static section ///////////////////////

  void changeAnimationOnTap(Offset point) {
    if (_area.contains(point)) {
      _currentDirection = _currentDirection.getNext();
      _currentAnimation = _animationFor[_currentDirection]!;
    }
  }

  void update(double dt) {
    _currentAnimation.update(dt);
  }

  void render(Canvas canvas) {
    _currentAnimation
        .getSprite()
        .render(canvas, position: _position, size: _size);
  }

  Vector2 _position;
  final Vector2 _size;
  late final Rect _area;
  Direction _currentDirection = Direction.down;
  late SpriteAnimation _currentAnimation;
  late final Map<Direction, SpriteAnimation> _animationFor;
}
