import 'package:basic_flame_game/character.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(GameWidget(game: MyGame()));

late Character character;

class MyGame extends Game with TapDetector {
  @override
  Future<void> onLoad() async {
    character = await Character.createAsync('bald.png');
  }

  @override
  void onTapDown(TapDownInfo event) {
    character.changeAnimationOnTap(event.eventPosition.game.toOffset());
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) => character.update(dt);

  @override
  void render(Canvas canvas) {
    character.render(canvas);
  }
}
