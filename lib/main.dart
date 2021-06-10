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
var clickedSquare = Vector2(0, 0);

final _linePaint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 3
  ..strokeCap = StrokeCap.round;

class MyGame extends Game with KeyboardEvents, TapDetector {
  @override
  Future<void> onLoad() async {
    RawKeyboard.instance.keyEventHandler = (event) => true;
    character = await Character.create('bald.png', start: Position(0, 0));
  }

  @override
  void onKeyEvent(RawKeyEvent keyEvent) {
    print(keyEvent.data);

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
    super.onTapDown(event);
    final point = event.eventPosition.game.toOffset();
    print('${(point.dx / 64).floor()}, ${(point.dy / 64).floor()}');
    clickedSquare = Vector2(
        (point.dx / 64).floor().toDouble(), (point.dy / 64).floor().toDouble());
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) => character.update(dt);

  @override
  void render(Canvas canvas) {
    // Draw the grid.
    for (double i = 0; i <= 1280; i += 64) {
      canvas.drawLine(Offset(0, i), Offset(1720, i), _linePaint);
    }
    for (double i = 0; i <= 1280; i += 64) {
      canvas.drawLine(Offset(i, 0), Offset(i, 1720), _linePaint);
    }

    // Draw the selected square.
    canvas.drawRect(
        Rect.fromPoints((clickedSquare * 64).toOffset(),
            ((clickedSquare + Vector2(1, 1)) * 64).toOffset()),
        Paint()..color = Colors.lightGreen);

    // Draw our character
    character.render(canvas);
  }
}
