import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(game: MyGame()),
  );
}

class MyGame extends Game {
  late SpriteAnimation runningRobot;

  // Vector2 is a class from `package:vector_math/vector_math_64.dart` and is widely used
  // in Flame to represent vectors. Here we need two vectors, one to define where we are
  // going to draw our robot and another one to define its size
  final robotPosition = Vector2(240, 50);
  final robotSize = Vector2(48, 60);

  // Now, on the `onLoad` method, we need to load our animation. To do that we can use the
  // `loadSpriteAnimation` method, which is present on our game class.
  @override
  Future<void> onLoad() async {
    runningRobot = await loadSpriteAnimation(
      'bald.png',
      // `SpriteAnimationData` is a class used to tell Flame how the animation Sprite Sheet
      // is organized. In this case we are describing that our frames are laid out in a horizontal
      // sequence on the image, that there are 8 frames, that each frame is a sprite of 16x18 pixels,
      // and, finally, that each frame should appear for 0.1 seconds when the animation is running.
      SpriteAnimationData.sequenced(
          amount: 16,
          textureSize: Vector2(32, 32),
          stepTime: 0.1,
          texturePosition: Vector2(96, 0)),
    );
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) {
    // Here we just need to "hook" our animation into the game loop update method so the current frame is updated with the specified frequency
    runningRobot.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Since an animation is basically a list of sprites, to render it, we just need to get its
    // current sprite and render it on our canvas. Which frame is the current sprite is updated on the `update` method.
    runningRobot
        .getSprite()
        .render(canvas, position: robotPosition, size: robotSize);
  }
}
