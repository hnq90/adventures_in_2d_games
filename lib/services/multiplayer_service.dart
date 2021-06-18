import 'dart:async';
import 'dart:convert';

import 'package:adventures_in_2d_games/models/networking/movement_path.dart';
import 'package:adventures_in_2d_games/utilities/constants.dart';
import 'package:flame/extensions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../extensions/offsets_list_extension.dart';

class MultiplayerService {
  MultiplayerService(String userId) : _userId = userId {
    // listen to the websocket and react to path data
    _webSocket = WebSocketChannel.connect(Uri.parse(us_central1));
    _subscription = _webSocket.stream.listen((data) {
      final pathData = MovementPath.fromJson(jsonDecode(data));
      if (pathData.userId == _userId) {
        print('ws: ${DateTime.now().millisecondsSinceEpoch - _departureTime}');
        print('Received data: $data');
      }
    }, onError: _error, onDone: _done);
  }

  final String _userId;
  late final WebSocketChannel _webSocket;
  late final StreamSubscription _subscription;
  int _departureTime = 0;

  publishPath(List<Offset> pathUnits) {
    final movementPath =
        MovementPath(userId: _userId, points: pathUnits.toValues());

    // record time and send data via websocket
    _departureTime = DateTime.now().millisecondsSinceEpoch;
    _webSocket.sink.add(jsonEncode(movementPath.toJson()));
  }

  _error(err) => print('${DateTime.now()} > CONNECTION ERROR: $err');

  _done() =>
      '${DateTime.now()} > CONNECTION DONE! closeCode=${_webSocket.closeCode}, closeReason= ${_webSocket.closeReason}';

  Future<dynamic> close() async {
    await _subscription.cancel();
    return _webSocket.sink.close();
  }
}
