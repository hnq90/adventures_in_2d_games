import 'package:adventures_in_2d_games/utilities/double2.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_path.freezed.dart';
part 'movement_path.g.dart';

@freezed
class MovementPath with _$MovementPath {
  factory MovementPath(
      {required String userId, required List<Double2> points}) = _MovementPath;

  factory MovementPath.fromJson(Map<String, Object?> json) =>
      _$MovementPathFromJson(json);
}
