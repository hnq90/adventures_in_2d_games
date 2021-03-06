import 'dart:async';
import 'dart:convert';

import 'package:adventures_in_2d_games/redux/actions/store_present_list_action.dart';
import 'package:flame/extensions.dart';
import 'package:redux/redux.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_game_server_types/web_socket_game_server_types.dart';

import '../extensions/offsets_list_extension.dart';
import '../redux/actions/store_movement_path_action.dart';
import '../redux/state/app/app_state.dart';
import '../redux/state/game/movement_path.dart';
import '../utilities/constants.dart' as constants;

class MultiplayerService {
  MultiplayerService(String userId, Store<AppState> store)
      : _userId = userId,
        _reduxStore = store {
    final uriString = constants.us_central1;
    // Connect to the server via a websocket and announce presence.
    _webSocket = WebSocketChannel.connect(Uri.parse(uriString));
    _webSocket.sink.add(jsonEncode(AnnouncePresence(userId).toJson()));

    // Attach callbacks to the websocket.
    _subscription =
        _webSocket.stream.listen(_handleEvent, onError: _error, onDone: _done);

    // For debugging.
    print('Connected to websocket at $uriString');
  }

  final String _userId;
  late final WebSocketChannel _webSocket;
  late final StreamSubscription _subscription;
  late final Store<AppState> _reduxStore;
  int _departureTime = 0;

  publishPath(List<Offset> pathUnits) {
    final movementPath =
        MovementPath(userId: _userId, points: pathUnits.toValues());

    // record time and send data via websocket
    _departureTime = DateTime.now().millisecondsSinceEpoch;
    final jsonString = jsonEncode(movementPath.toJson());
    _webSocket.sink.add(jsonString);
  }

  Future<dynamic> close() async {
    await _subscription.cancel();
    return _webSocket.sink.close();
  }

  // Handle each event that comes through the websocket
  _handleEvent(data) {
    final jsonData = jsonDecode(data);

    // Check the type of data in the event and respond appropriately.
    if (jsonData['type'] == 'present_list') {
      final presentList = PresentList.fromJson(jsonData);
      _reduxStore.dispatch(StorePresentListAction(presentList));
      print(presentList);
    } else {
      final pathData = MovementPath.fromJson(jsonData);
      _reduxStore.dispatch(StoreMovementPathAction(pathData));
      if (pathData.userId == _userId) {
        print('ws: ${DateTime.now().millisecondsSinceEpoch - _departureTime}');
        print('Received data: $data');
      }
    }
  }

  _error(err) => print('${DateTime.now()} > CONNECTION ERROR: $err');

  _done() =>
      '${DateTime.now()} > CONNECTION DONE! closeCode=${_webSocket.closeCode}, closeReason= ${_webSocket.closeReason}';
}
