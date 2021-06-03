import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

enum Direction { up, down, left, right }

extension DirectionExtension on Direction {
  Direction getNext() =>
      Direction.values[(index + 1) % Direction.values.length];
}

const Map<Direction, double> start = {
  Direction.up: 192,
  Direction.down: 96,
  Direction.left: 0,
  Direction.right: 288
};

void main() => runApp(GameWidget(game: MyGame()));

class MyGame extends Game with TapDetector {
  Map<Direction, SpriteAnimation> animationFor = {};
  late SpriteAnimation currentAnimation;
  Direction currentDirection = Direction.down;

  final baldPosition = Vector2(240, 50);
  final baldSize = Vector2(60, 60);

  Future<SpriteAnimation> _loadSpriteAnimation(Direction direction) =>
      loadSpriteAnimation(
        'bald.png',
        SpriteAnimationData.sequenced(
            amount: 3,
            textureSize: Vector2(32, 32),
            stepTime: 0.1,
            texturePosition: Vector2(start[direction]!, 0)),
      );

  @override
  Future<void> onLoad() async {
    for (var direction in Direction.values) {
      animationFor[direction] = await _loadSpriteAnimation(direction);
    }
    currentAnimation = animationFor[currentDirection]!;
  }

  @override
  void onTapDown(TapDownInfo event) {
    final baldArea = baldPosition & baldSize;

    if (baldArea.contains(event.eventPosition.game.toOffset())) {
      currentDirection = currentDirection.getNext();
      currentAnimation = animationFor[currentDirection]!;
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) => currentAnimation.update(dt);

  @override
  void render(Canvas canvas) {
    // Since an animation is basically a list of sprites, to render it, we just need to get its
    // current sprite and render it on our canvas. Which frame is the current sprite is updated on the `update` method.
    currentAnimation
        .getSprite()
        .render(canvas, position: baldPosition, size: baldSize);
  }
}
