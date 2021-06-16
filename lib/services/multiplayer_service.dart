import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adventures_in_2d_games/models/networking/movement_path.dart';
import 'package:adventures_in_2d_games/pub_nub_keys.dart';
import 'package:adventures_in_2d_games/utilities/constants.dart';
import 'package:flame/extensions.dart';
import 'package:pubnub/pubnub.dart';

import '../extensions/offsets_list_extension.dart';

class MultiplayerService {
  MultiplayerService(String userId)
      : _userId = userId,
        _pubnub = PubNub(
            defaultKeyset: Keyset(
                subscribeKey: subscribe,
                publishKey: publish,
                uuid: UUID(userId))) {
    _characterMovementSubscription =
        _pubnub.subscribe(channels: {'character_movement'});

    _characterMovementSubscription.messages.listen((event) {
      final pathData = MovementPath.fromJson(event.content);
      if (pathData.userId == _userId) {
        print(
            'pn: ${DateTime.now().millisecondsSinceEpoch - _pubNubDepartureTime}');
      }
    });
  }

  final String _userId;
  final PubNub _pubnub;
  late final WebSocket _webSocket;
  late final Subscription _characterMovementSubscription;
  late final StreamSubscription _webSocketSubscription;
  int _pubNubDepartureTime = 0;
  int _webSocketDepartureTime = 0;

  Future<int> setupWebSocket() async {
    _webSocket = await WebSocket.connect(australia_southeast1);

    _webSocketSubscription = _webSocket.listen((data) {
      print(
          'ws: ${DateTime.now().millisecondsSinceEpoch - _webSocketDepartureTime}');
      final pathData = MovementPath.fromJson(jsonDecode(data));
      if (pathData.userId == _userId) {
        print('Received data: $data');
        print(DateTime.now().millisecondsSinceEpoch - _webSocketDepartureTime);
      }
    }, onError: _error, onDone: _done);

    return _webSocket.readyState;
  }

  publishPath(List<Offset> pathUnits) {
    final movementPath =
        MovementPath(userId: _userId, points: pathUnits.toValues());

    // record time and send data via pubub
    _pubNubDepartureTime = DateTime.now().millisecondsSinceEpoch;
    _pubnub.publish('character_movement', movementPath);

    // record time and send data via websocket
    _webSocketDepartureTime = DateTime.now().millisecondsSinceEpoch;
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
}
