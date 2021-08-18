import 'package:adventures_in_2d_games/redux/actions/store_present_list_action.dart';
import 'package:adventures_in_2d_games/redux/state/app/app_state.dart';
import 'package:redux/redux.dart';

class StorePresentListReducer
    extends TypedReducer<AppState, StorePresentListAction> {
  StorePresentListReducer()
      : super(
          (state, action) => state.copyWith.game(
              presentIds: state.game.presentIds
                ..addAll(action.presentList.ids)),
        );
}
