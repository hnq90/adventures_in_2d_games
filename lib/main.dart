import 'package:adventures_in_2d_games/main_page.dart';
import 'package:adventures_in_2d_games/middleware/store_auth_user_data_middleware.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:redfire/app-init/widgets/app_widget.dart';

import 'state/app_state.dart';

void main() => runApp(AppWidget<AppState>(
      initialState: AppState.init(),
      initialActions: [],
      middlewares: [StoreAuthUserDataMiddleware()],
      reducers: [],
      mainPage: GameWidget(game: AdventuresIn2dGame()),
    ));
