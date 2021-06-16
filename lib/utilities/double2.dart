class Double2 {
  Double2(this.x, this.y);
  double x;
  double y;

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
  factory Double2.fromJson(Map<String, dynamic> json) =>
      Double2(json['x'] as double, json['y'] as double);
}
