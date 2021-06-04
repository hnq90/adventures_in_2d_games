import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:pubnub/pubnub.dart';

List<Offset> result = AStar(
  rows: 20,
  columns: 20,
  start: Offset(5, 0),
  end: Offset(8, 19),
  barriers: [
    Offset(10, 5),
    Offset(10, 6),
    Offset(10, 7),
    Offset(10, 8),
  ],
).findThePath();

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

void main() {
  var pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: 'sub-c-a12a287e-c468-11eb-9e40-ea6857a81ff7',
          publishKey: 'pub-c-5d34f973-30dc-4083-9714-52b067f7efd8',
          uuid: UUID('ReplaceWithYourClientIdentifier')));

  return runApp(GameWidget(game: MyGame()));
}

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
    currentAnimation
        .getSprite()
        .render(canvas, position: baldPosition, size: baldSize);
  }
}
