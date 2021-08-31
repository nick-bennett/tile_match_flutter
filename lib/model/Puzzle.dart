import 'dart:math';

import 'Tile.dart';

class Puzzle {
  final int _size;
  late List<Tile> _tiles;
  final List<int> _selections;
  PuzzleState _state = PuzzleState.IN_PROGRESS;
  int _moves = 0;
  int _matches = 0;
  Tile? _selection;

  Puzzle(int size, int imagePoolSize, Random rng)
      : _size = size,
        _selections = List.empty(growable: true) {
    final pool = List.generate(imagePoolSize, (index) => index);
    pool.shuffle(rng);
    final rawTiles = pool
        .sublist(0, (size / 2).floor())
        .expand((value) => [Tile(value), Tile(value)])
        .toList();
    rawTiles.shuffle(rng);
    _tiles = List.unmodifiable(rawTiles);
  }

  List<Tile> get tiles => _tiles;

  List<int> get selections => _selections;

  PuzzleState get state => _state;

  int get moves => _moves;

  int get matches => _matches;

  select(int position) {
    _selections.add(position);
    final tile = _tiles[position];
    if (tile.state == TileState.hidden) {
      switch (_state) {
        case PuzzleState.IN_PROGRESS:
          _state = PuzzleState.GUESSING;
          tile.state = TileState.selected;
          _selection = tile;
          break;
        case PuzzleState.GUESSING:
          _moves++;
          _state = PuzzleState.REVEALING;
          tile.state = TileState.selected;
          if (_selection?.imageIndex == tile.imageIndex) {
            _matches++;
            _state = (_matches / 2 >= _size)
                ? PuzzleState.COMPLETED
                : PuzzleState.IN_PROGRESS;
            tile.state = TileState.solved;
            _selection!.state = TileState.solved;
          }
          _selection = null;
          break;
        case PuzzleState.REVEALING:
        // Fall-through.
        case PuzzleState.COMPLETED:
          // Ignore the selection.
          break;
      }
    }
  }

  unreveal() {
    if (_state == PuzzleState.REVEALING) {
      _tiles
          .where((tile) => tile.state == TileState.selected)
          .forEach((tile) {
            tile.state == TileState.hidden;
          });
      _state = PuzzleState.IN_PROGRESS;
    }
  }

}

enum PuzzleState { IN_PROGRESS, GUESSING, REVEALING, COMPLETED }
