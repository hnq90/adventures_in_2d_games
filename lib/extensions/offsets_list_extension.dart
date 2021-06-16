import 'package:adventures_in_2d_games/utilities/double2.dart';
import 'package:flutter/widgets.dart';

extension OffsetsListExtension on List<Offset> {
  List<Double2> toValues() =>
      map<Double2>((offset) => Double2(offset.dx, offset.dy)).toList();
}
