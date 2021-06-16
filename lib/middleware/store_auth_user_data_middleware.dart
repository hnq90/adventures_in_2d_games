import 'package:adventures_in_2d_games/services/locator.dart';
import 'package:adventures_in_2d_games/services/multiplayer_service.dart';
import 'package:adventures_in_2d_games/state/app_state.dart';
import 'package:redfire/actions/store_auth_user_data_action.dart';
import 'package:redux/redux.dart';

class StoreAuthUserDataMiddleware
    extends TypedMiddleware<AppState, StoreAuthUserDataAction> {
  StoreAuthUserDataMiddleware()
      : super((store, action, next) async {
          next(action);

          if (action.authUserData == null) return;

          final service = MultiplayerService(action.authUserData!.uid);
          final readyState = await service.setupWebSocket();
          print('readyState=$readyState');
          MultiplayerLocator.provide(service);
        });
}
