import 'package:flutter/material.dart';
import 'package:tetris_game/values.dart';

class Piece {
  TetrominoType type;
  Piece({required this.type});

  //the piece is the list of integers/
  List<int> positions = [];
  Color get color => tetrominoColors[type] ?? Colors.white;

  //Generate the integers
  void initializePiece() {
    switch (type) {
      case TetrominoType.I:
        positions = [-4, -5, -6, -7];
        break;
      case TetrominoType.O:
        positions = [-15, -16, -5, -6];
        break;
      case TetrominoType.T:
        positions = [-26, -16, -6, -15];
        break;
      case TetrominoType.S:
        positions = [-15, -14, -6, -5];
        break;
      case TetrominoType.Z:
        positions = [-17, -16, -6, -5];
        break;
      case TetrominoType.J:
        positions = [-25, -15, -5, -6];
        break;
      case TetrominoType.L:
        positions = [-26, -16, -6, -5];
        break;
    }
  }

  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.left:
        for (int i = 0; i < positions.length; i++) {
          positions[i] -= 1;
          //sub 1
        }
        break;
      case Direction.right:
        for (int i = 0; i < positions.length; i++) {
          positions[i] += 1;
          //add 1
        }
        break;
      case Direction.down:
        for (int i = 0; i < positions.length; i++) {
          // positions[i] += 10;
          positions[i] += rowCount;
        }
        break;
    }
  }
}
