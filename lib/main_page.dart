import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:adventures_in_2d_games/services/locator.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'effects/sprite_move_effect.dart';
import 'extensions/offset_extension.dart';
import 'extensions/raw_key_event_extension.dart';
import 'extensions/vector2_extension.dart';
import 'models/domain/barriers.dart';
import 'models/domain/character.dart';

late Character _character;
SpriteDirectionEffect? _directionEffect;
MoveEffect? _moveEffect;
bool _paused = false;
var _clickedUnit = Vector2(0, 0);
List<Offset> _pathUnits = [];

int departureTime = 0;

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
    _clickedUnit = point.toUnit();

    _pathUnits = AStar(
      rows: 10,
      columns: 10,
      start: _clickedUnit.toOffset(),
      end: _character.position.toUnit().toOffset(),
      barriers: barriers,
    ).findThePath()
      ..add(_clickedUnit.toOffset());

    final pathVectors =
        _pathUnits.map((offset) => (offset).toVector2() * 64).toList();

    final multiplayerService = MultiplayerLocator.getService();
    departureTime = DateTime.now().millisecondsSinceEpoch;
    multiplayerService.publishPath(_pathUnits);

    if (_directionEffect != null) _character.removeEffect(_directionEffect!);
    if (_moveEffect != null) _character.removeEffect(_moveEffect!);

    _directionEffect =
        SpriteDirectionEffect(speed: 300, pathPoints: pathVectors);
    _moveEffect = MoveEffect(speed: 300, path: pathVectors);

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

    for (final barrier in barriers) {
      canvas.drawRect(barrier.toRect64(), Paint()..color = Colors.red);
    }

    for (final pathUnit in _pathUnits) {
      canvas.drawRect(pathUnit.toRect64(), Paint()..color = Colors.blue);
    }

    // Draw the selected square.
    canvas.drawRect(
        _clickedUnit.toRect64(), Paint()..color = Colors.lightGreen);

    // Draw our character
    _character.render(canvas);
  }
}
