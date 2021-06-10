import 'package:adventures_in_2d_games/character.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension RawKeyEventExtension on RawKeyEvent {
  bool get isSpaceDown =>
      this is RawKeyDownEvent && data.logicalKey.keyId == 32;
}

void main() => runApp(GameWidget(game: MyGame()));

late Character character;
bool paused = false;

final _linePaint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 3
  ..strokeCap = StrokeCap.round;

class MyGame extends Game with KeyboardEvents, TapDetector {
  @override
  Future<void> onLoad() async {
    RawKeyboard.instance.keyEventHandler = (event) => true;
    character = await Character.create('bald.png');
  }

  @override
  void onKeyEvent(RawKeyEvent keyEvent) {
    if (keyEvent.isSpaceDown) return _togglePausedState();

    // otherwise we change the direction of movement
    character.changeDirection(keyEvent);
  }

  void _togglePausedState() {
    if (paused) {
      paused = false;
      resumeEngine();
    } else {
      paused = true;
      pauseEngine();
    }
    return;
  }

  @override
  void onTapDown(TapDownInfo event) {
    final point = event.eventPosition.game.toOffset();
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) => character.update(dt);

  @override
  void render(Canvas canvas) {
    character.render(canvas);
    canvas.drawLine(Offset(0, 0), Offset(64, 0), _linePaint);
  }
}
