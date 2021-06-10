import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';

import 'enums/direction.dart';
import 'input.dart';

typedef Position = Vector2;

class Character extends SpriteAnimationGroupComponent<Direction> {
  // Private constructor - the async create method is how an object is created.
  Character._(Map<Direction, SpriteAnimation> animations,
      {required Position start})
      : super(
            size: Vector2(64, 64),
            position: start,
            animations: animations,
            current: Direction.down);

  // Static async create method so we can load sprite animations.
  static Future<Character> create(String path) async {
    final animations = <Direction, SpriteAnimation>{};

    // The x position of each sprite in the sprite sheet.
    const spriteX = <double>[192, 0, 96, 288];

    for (var direction in Direction.values) {
      animations[direction] = await SpriteAnimation.load(
          path,
          SpriteAnimationData.sequenced(
              amount: 3,
              textureSize: Vector2(32, 32),
              stepTime: 0.1,
              texturePosition: Vector2(spriteX[direction.index], 0)));
    }

    return Character._(animations, start: Position(240, 50));
  }

  void changeDirection(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      current = Input.directionFrom(event);
      final newPoint = position + current.vector;
      addEffect(MoveEffect(path: [newPoint], speed: 200.0));
    }
  }

  void update(double dt) => super.update(dt);
  void render(Canvas canvas) => super.render(canvas);
}
