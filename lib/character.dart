import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart' as game;
import 'package:flutter/services.dart';

import 'enums/direction.dart';
import 'input.dart';

typedef StartPos = Map<Direction, double>;

const StartPos startPosFor = {
  Direction.up: 192,
  Direction.down: 0,
  Direction.left: 96,
  Direction.right: 288
};

final Map<Direction, Vector2> vectorFor = {
  Direction.up: Vector2(0, -1),
  Direction.down: Vector2(0, 1),
  Direction.left: Vector2(-1, 0),
  Direction.right: Vector2(1, 0)
};

class Character {
  // Private constructor.
  Character._(Map<Direction, SpriteAnimation> animationFor,
      {Vector2? position, Vector2? size})
      : _currentPosition = position ?? Vector2(240, 50),
        _size = size ?? Vector2(60, 60) {
    _area = _currentPosition & _size;
    _animationFor = animationFor;
    _currentAnimation = animationFor[_currentDirection]!;
  }

  ////////////////// start static section ///////////////////////

  // Static async create method so we can load sprite animations.
  static Future<Character> create(String path) async {
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

  void changeDirection(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final eventDirection = Input.directionFrom(event);
      if (eventDirection != null) {
        _currentDirection = eventDirection;
        _currentAnimation = _animationFor[_currentDirection]!;
      }
    }
  }

  void update(double dt) {
    _currentAnimation.update(dt);
    final positionDelta = vectorFor[_currentDirection]! * 0.5;
    _currentPosition += positionDelta;
  }

  void render(Canvas canvas) {
    _currentAnimation
        .getSprite()
        .render(canvas, position: _currentPosition, size: _size);
  }

  Vector2 _currentPosition;
  final Vector2 _size;
  late final Rect _area;
  Direction _currentDirection = Direction.down;
  late SpriteAnimation _currentAnimation;
  late final Map<Direction, SpriteAnimation> _animationFor;
}
