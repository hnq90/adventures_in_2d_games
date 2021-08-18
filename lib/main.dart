import 'package:adventures_in_2d_games/redux/reducers/store_present_list_reducer.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redfire/widgets.dart';

import 'adventures_in_2d_games.dart';
import 'redux/middleware/store_auth_user_data_middleware.dart';
import 'redux/state/app/app_state.dart';
import 'redux/state/game/game_state.dart';

void main() {
  runApp(
    AppWidget<AppState>(
        initialState: AppState.init(),
        initialActions: [],
        middlewares: [StoreAuthUserDataMiddleware()],
        reducers: [StorePresentListReducer()],
        mainPage: StoreConnector<AppState, GameState>(
            onInit: (store) => {
                  // This stops the beeping on macos.
                  RawKeyboard.instance.keyEventHandler = (event) => true
                },
            distinct: true,
            converter: (store) => store.state.game,
            builder: (context, gameState) =>
                GameWidget(game: AdventuresIn2dGame(gameState)))),
  );
}
