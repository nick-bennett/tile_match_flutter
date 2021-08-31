class Tile {
  final _imageIndex;
  TileState _state;

  Tile(int imageIndex)
      : _imageIndex = imageIndex,
        _state = TileState.hidden;

  int get imageIndex => _imageIndex;

  TileState get state => _state;

  set state(TileState state) => _state = state;
}

enum TileState { hidden, selected, solved }
