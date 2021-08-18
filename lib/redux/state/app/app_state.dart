import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:redfire/types.dart';

import '../../../redux/state/game/game_state.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
class AppState with _$AppState, RedFireState {
  factory AppState({
    required IList<RedFirePage> pages,
    required IList<ProblemInfo> problems,
    required Settings settings,
    required AuthState auth,
    required GameState game,
  }) = _AppState;

  factory AppState.init() => AppState(
      pages: <RedFirePage>[RedFireInitialPage()].lock,
      problems: IList(),
      settings: Settings.init(),
      auth: AuthState.init(),
      game: GameState.init());

  factory AppState.fromJson(Map<String, Object?> json) =>
      _$AppStateFromJson(json);
}
