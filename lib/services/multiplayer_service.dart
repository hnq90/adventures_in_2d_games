import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adventures_in_2d_games/models/networking/movement_path.dart';
import 'package:adventures_in_2d_games/utilities/constants.dart';
import 'package:flame/extensions.dart';

import '../extensions/offsets_list_extension.dart';

class MultiplayerService {
  MultiplayerService._(String userId, WebSocket websocket)
      : _userId = userId,
        _webSocket = websocket {
    // listen to the websocket and react to path data
    _subscription = _webSocket.listen((data) {
      print('ws: ${DateTime.now().millisecondsSinceEpoch - _departureTime}');
      final pathData = MovementPath.fromJson(jsonDecode(data));
      if (pathData.userId == _userId) {
        print('Received data: $data');
        print(DateTime.now().millisecondsSinceEpoch - _departureTime);
      }
    }, onError: _error, onDone: _done);
  }

  final String _userId;
  late final WebSocket _webSocket;
  late final StreamSubscription _subscription;
  int _departureTime = 0;

  static Future<MultiplayerService> create(String userId) async {
    // ignore: close_sinks
    final websocket = await WebSocket.connect(australia_southeast1);
    return MultiplayerService._(userId, websocket);
  }

  publishPath(List<Offset> pathUnits) {
    final movementPath =
        MovementPath(userId: _userId, points: pathUnits.toValues());

    // record time and send data via websocket
    _departureTime = DateTime.now().millisecondsSinceEpoch;
    _webSocket.add(jsonEncode(movementPath.toJson()));
  }

  _error(err) async {
    print(new DateTime.now().toString() + " CONNECTION ERROR: $err");
  }

  _done() async {
    print(new DateTime.now().toString() +
        " CONNECTION DONE! \n" +
        "readyState=" +
        _webSocket.readyState.toString() +
        "\n" +
        "closeCode=" +
        _webSocket.closeCode.toString() +
        "\n" +
        "closeReason=" +
        _webSocket.closeReason.toString() +
        "\n");
  }

  Future<dynamic> close() async {
    await _subscription.cancel();
    return _webSocket.close();
  }
}
