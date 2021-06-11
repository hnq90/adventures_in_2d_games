import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:adventures_in_2d_games/character.dart';
import 'package:adventures_in_2d_games/extensions/offset_extension.dart';
import 'package:adventures_in_2d_games/extensions/vector2_extension.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
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

late Character _character;
MoveEffect? _effect;
bool _paused = false;
var _clickedSquare = Vector2(0, 0);
List<Offset> _pathSquares = [];
List<Offset> _barriers = [
  Offset(5, 2),
  Offset(5, 3),
  Offset(5, 4),
  Offset(5, 5),
  Offset(5, 6),
  Offset(5, 7),
  Offset(5, 8),
  Offset(5, 9),
  Offset(7, 7),
  Offset(7, 8),
  Offset(6, 8),
  Offset(1, 0),
  Offset(1, 1),
  Offset(1, 2),
  Offset(1, 3),
  Offset(1, 4),
  Offset(1, 5),
  Offset(1, 6),
  Offset(1, 7),
  Offset(1, 8),
];

final _linePaint = Paint()
  ..color = Colors.blue
  ..strokeWidth = 3
  ..strokeCap = StrokeCap.round;

class MyGame extends Game with KeyboardEvents, TapDetector {
  @override
  Future<void> onLoad() async {
    RawKeyboard.instance.keyEventHandler = (event) => true;
    _character = await Character.create('bald.png', start: Position(0, 0));
  }

  @override
  void onKeyEvent(RawKeyEvent keyEvent) {
    print(keyEvent.data);

    if (keyEvent.isSpaceDown) return _togglePausedState();

    // otherwise we change the direction of movement
    _character.changeDirection(keyEvent);
  }

  void _togglePausedState() {
    if (_paused) {
      _paused = false;
      resumeEngine();
    } else {
      _paused = true;
      pauseEngine();
    }
    return;
  }

  @override
  void onTapDown(TapDownInfo event) {
    super.onTapDown(event);
    final point = event.eventPosition.game.toOffset();
    _clickedSquare = point.toSquare();

    _pathSquares = AStar(
      rows: 10,
      columns: 10,
      start: _character.position.toSquare().toOffset(),
      end: _clickedSquare.toOffset(),
      barriers: _barriers,
    ).findThePath();

    if (_effect != null) _character.removeEffect(_effect!);

    _effect = MoveEffect(
        speed: 300,
        isRelative: false,
        isAlternating: false,
        path: (_pathSquares..insert(0, _clickedSquare.toOffset()))
            .map((offset) => (offset).toVector2() * 64)
            .toList()
            .reversed
            .toList());

    _character.addEffect(_effect!);
  }

  @override
  Color backgroundColor() => const Color(0xFF222222);

  @override
  void update(double dt) => _character.update(dt);

  @override
  void render(Canvas canvas) {
    // Draw the grid.
    for (double i = 0; i <= 640; i += 64) {
      canvas.drawLine(Offset(0, i), Offset(640, i), _linePaint);
    }
    for (double i = 0; i <= 640; i += 64) {
      canvas.drawLine(Offset(i, 0), Offset(i, 640), _linePaint);
    }

    for (final barrier in _barriers) {
      canvas.drawRect(barrier.toRect64(), Paint()..color = Colors.red);
    }

    for (final square in _pathSquares) {
      canvas.drawRect(square.toRect64(), Paint()..color = Colors.blue);
    }

    // Draw the selected square.
    canvas.drawRect(
        _clickedSquare.toRect64(), Paint()..color = Colors.lightGreen);

    // Draw our character
    _character.render(canvas);
  }
}
