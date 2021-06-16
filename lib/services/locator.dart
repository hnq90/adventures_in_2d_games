import 'package:adventures_in_2d_games/services/multiplayer_service.dart';

class MultiplayerLocator {
  static MultiplayerService getService() => _service;
  static void provide(MultiplayerService service) => _service = service;
  static late MultiplayerService _service;
}
