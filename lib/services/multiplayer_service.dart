import 'dart:async';
import 'dart:convert';

import 'package:adventures_in_2d_games/models/networking/movement_path.dart';
import 'package:adventures_in_2d_games/utilities/constants.dart' as constants;
import 'package:flame/extensions.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_game_server_types/web_socket_game_server_types.dart';

import '../extensions/offsets_list_extension.dart';

class MultiplayerService {
  MultiplayerService(String userId) : _userId = userId {
    final uriString = constants.localhost;
    // listen to the websocket and react to path data
    _webSocket = WebSocketChannel.connect(Uri.parse(uriString));
    _webSocket.sink.add(jsonEncode(AnnouncePresence(userId).toJson()));
    _subscription = _webSocket.stream.listen((data) {
      final jsonData = jsonDecode(data);
      if (jsonData['type'] == 'present_list') {
        final presentList = PresentList.fromJson(jsonData);
        print(presentList);
      } else {
        final pathData = MovementPath.fromJson(jsonData);
        if (pathData.userId == _userId) {
          print(
              'ws: ${DateTime.now().millisecondsSinceEpoch - _departureTime}');
          print('Received data: $data');
        }
      }
    }, onError: _error, onDone: _done);
    print('Connected to websocket at $uriString');
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
    final jsonString = jsonEncode(movementPath.toJson());
    _webSocket.sink.add(jsonString);
  }

  _error(err) => print('${DateTime.now()} > CONNECTION ERROR: $err');

  _done() =>
      '${DateTime.now()} > CONNECTION DONE! closeCode=${_webSocket.closeCode}, closeReason= ${_webSocket.closeReason}';

  Future<dynamic> close() async {
    await _subscription.cancel();
    return _webSocket.sink.close();
  }
}
