class ImcModel {
  double _height = 0.0;
  double _weight = 0.0;

  ImcModel(this._height, this._weight);

  double get height => _height;

  double get weight => _weight;

  void set height(double height) => _height = height;

  void set weight(double weight) => _weight = weight;
}
