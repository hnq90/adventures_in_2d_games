import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:adventures_in_2d_games/character.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'character.dart';
import 'effects/sprite_move_effect.dart';
import 'extensions/offset_extension.dart';
import 'extensions/raw_key_event_extension.dart';
import 'extensions/vector2_extension.dart';

late Character _character;
SpriteDirectionEffect? _directionEffect;
MoveEffect? _moveEffect;
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

class AdventuresIn2dGame extends Game with KeyboardEvents, TapDetector {
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
    // _character.changeDirection(keyEvent);
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

    if (_directionEffect != null) _character.removeEffect(_directionEffect!);
    if (_moveEffect != null) _character.removeEffect(_moveEffect!);

    // add the square that was clicked to the path and reverse the order
    final reversedPath = (_pathSquares..insert(0, _clickedSquare.toOffset()))
        .map((offset) => (offset).toVector2() * 64)
        .toList()
        .reversed
        .toList();

    _directionEffect =
        SpriteDirectionEffect(speed: 300, pathPoints: reversedPath);
    _moveEffect = MoveEffect(speed: 300, path: reversedPath);

    _character.addEffect(_directionEffect!);
    _character.addEffect(_moveEffect!);
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
