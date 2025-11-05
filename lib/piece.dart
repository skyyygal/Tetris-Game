import 'package:flutter/material.dart';
import 'package:tetris_game/game_board.dart';

import 'utils.dart';

class Piece {
  final TetrominoType type;
  List<int> positions = [];
  int rotationIndex = 0;

  Piece({required this.type});

  Color get color => tetrominoColors[type]!;

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

  // void movePiece(Direction direction) {
  //   switch (direction) {
  //     case Direction.left:
  //       positions = positions.map((pos) => pos - 1).toList();
  //       break;
  //     case Direction.right:
  //       positions = positions.map((pos) => pos + 1).toList();
  //       break;
  //     case Direction.down:
  //       positions = positions.map((pos) => pos + rowCount).toList();
  //       break;
  //   }
  // }
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.left:
        positions = positions.map((pos) => pos - 1).toList();
        break;
      case Direction.right:
        positions = positions.map((pos) => pos + 1).toList();
        break;
      case Direction.down:
        positions = positions.map((pos) => pos + rowCount).toList();
        break;
    }
  }

  /*   static const Map<TetrominoType, List<List<List<int>>>> rotationOffsets = {
    TetrominoType.I: [
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [0, 2],
      ],
      [
        [1, 0],
        [0, 0],
        [1, 0],
        [2, 0],
      ],
      [
        [0, 1],
        [0, 0],
        [0, -1],
        [0, -2],
      ],
      [
        [1, 0],
        [0, 0],
        [-1, 0],
        [-2, 0],
      ],
    ],
    TetrominoType.O: [
      [
        [0, 0],
        [0, -1],
        [1, 0],
        [1, -1],
      ],
      [
        [0, 0],
        [0, -1],
        [1, 0],
        [1, -1],
      ],
      [
        [0, 0],
        [0, -1],
        [1, 0],
        [1, -1],
      ],
      [
        [0, 0],
        [0, -1],
        [1, 0],
        [1, -1],
      ],
    ],
    TetrominoType.T: [
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [1, 0],
      ],
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [0, -1],
      ],
      [
        [0, 1],
        [0, 0],
        [0, -1],
        [-1, 0],
      ],
      [
        [1, 0],
        [0, 0],
        [-1, 0],
        [0, 1],
      ],
    ],
    TetrominoType.S: [
      [
        [0, 0],
        [0, 1],
        [1, -1],
        [1, 0],
      ],
      [
        [-1, 0],
        [0, 0],
        [0, 1],
        [1, 1],
      ],
      [
        [0, 0],
        [0, 1],
        [1, -1],
        [1, 0],
      ],
      [
        [-1, 0],
        [0, 0],
        [0, 1],
        [1, 1],
      ],
    ],
    TetrominoType.Z: [
      [
        [0, -1],
        [0, 0],
        [1, 0],
        [1, 1],
      ],
      [
        [-1, 1],
        [0, 1],
        [0, 0],
        [1, 0],
      ],
      [
        [0, -1],
        [0, 0],
        [1, 0],
        [1, 1],
      ],
      [
        [-1, 1],
        [0, 1],
        [0, 0],
        [1, 0],
      ],
    ],
    TetrominoType.J: [
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [1, -1],
      ],
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [1, 1],
      ],
      [
        [-1, 1],
        [-1, 0],
        [0, 0],
        [1, 0],
      ],
      [
        [-1, -1],
        [0, -1],
        [0, 0],
        [0, 1],
      ],
    ],
    TetrominoType.L: [
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [1, 1],
      ],
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [-1, 1],
      ],
      [
        [-1, -1],
        [-1, 0],
        [0, 0],
        [1, 0],
      ],
      [
        [1, -1],
        [0, -1],
        [0, 0],
        [0, 1],
      ],
    ],
  }; */
  static const Map<TetrominoType, List<List<List<int>>>> rotationOffsets = {
    TetrominoType.I: [
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [2, 0],
      ], // 0° (horizontal)
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [0, 2],
      ], // 90°
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [2, 0],
      ], // 180° (same as 0°)
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [0, 2],
      ], // 270° (same as 90°)
    ],
    TetrominoType.O: [
      [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ], // All rotations same
      [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ],
      [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ],
      [
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
      ],
    ],
    TetrominoType.T: [
      [
        [0, -1],
        [-1, 0],
        [0, 0],
        [0, 1],
      ], // 0°
      [
        [-1, 0],
        [0, -1],
        [0, 0],
        [1, 0],
      ], // 90°
      [
        [0, 1],
        [0, 0],
        [1, 0],
        [0, -1],
      ], // 180°
      [
        [1, 0],
        [0, 0],
        [0, 1],
        [-1, 0],
      ], // 270°
    ],
    TetrominoType.S: [
      [
        [0, -1],
        [0, 0],
        [-1, 0],
        [-1, 1],
      ], // 0°
      [
        [-1, 0],
        [0, 0],
        [0, 1],
        [1, 1],
      ], // 90°
      [
        [0, 1],
        [0, 0],
        [1, 0],
        [1, -1],
      ], // 180°
      [
        [1, 0],
        [0, 0],
        [0, -1],
        [-1, -1],
      ], // 270°
    ],
    TetrominoType.Z: [
      [
        [0, -1],
        [0, 0],
        [1, 0],
        [1, 1],
      ], // 0°
      [
        [-1, 1],
        [0, 1],
        [0, 0],
        [1, 0],
      ], // 90°
      [
        [0, 1],
        [0, 0],
        [-1, 0],
        [-1, -1],
      ], // 180°
      [
        [1, -1],
        [0, -1],
        [0, 0],
        [-1, 0],
      ], // 270°
    ],
    TetrominoType.J: [
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [-1, 1],
      ], // 0°
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [1, 1],
      ], // 90°
      [
        [0, 1],
        [0, 0],
        [0, -1],
        [1, -1],
      ], // 180°
      [
        [1, 0],
        [0, 0],
        [-1, 0],
        [-1, -1],
      ], // 270°
    ],
    TetrominoType.L: [
      [
        [0, -1],
        [0, 0],
        [0, 1],
        [1, 1],
      ], // 0°
      [
        [-1, 0],
        [0, 0],
        [1, 0],
        [1, -1],
      ], // 90°
      [
        [0, 1],
        [0, 0],
        [0, -1],
        [-1, -1],
      ], // 180°
      [
        [1, 0],
        [0, 0],
        [-1, 0],
        [-1, 1],
      ], // 270°
    ],
  };

  void rotatePiece() {
    if (type == TetrominoType.O) return; // O piece doesn't rotate

    // Get the current rotation offsets
    List<List<int>> offsets = rotationOffsets[type]![rotationIndex];

    // Use the second block as anchor (index 1)
    int anchor = positions[1];
    int anchorRow = (anchor / rowCount).floor();
    int anchorCol = anchor % rowCount;

    List<int> newPositions = [];

    for (final offset in offsets) {
      int newRow = anchorRow + offset[0];
      int newCol = anchorCol + offset[1];
      int newIndex = newRow * rowCount + newCol;
      newPositions.add(newIndex);
    }

    // Check if new position is valid
    if (isValidPiecePosition(newPositions)) {
      positions = newPositions;
      rotationIndex = (rotationIndex + 1) % 4;
    } else {
      // Try wall kicks - shift left/right if rotation hits wall
      List<List<int>> kickTests = [
        [0, 0], // original position
        [0, -1], // shift left
        [0, 1], // shift right
        [-1, 0], // shift up
        [1, 0], // shift down
      ];

      for (final kick in kickTests) {
        List<int> kickedPositions = [];
        bool kickValid = true;

        for (final offset in offsets) {
          int newRow = anchorRow + offset[0] + kick[0];
          int newCol = anchorCol + offset[1] + kick[1];
          int newIndex = newRow * rowCount + newCol;
          kickedPositions.add(newIndex);

          if (!positionIsValid(newIndex)) {
            kickValid = false;
            break;
          }
        }

        if (kickValid && isValidPiecePosition(kickedPositions)) {
          positions = kickedPositions;
          rotationIndex = (rotationIndex + 1) % 4;
          break;
        }
      }
    }
  }

  bool positionIsValid(int position) {
    int row = (position / rowCount).floor();
    int col = position % rowCount;

    // Check boundaries
    if (row < 0 || row >= columnCount || col < 0 || col >= rowCount) {
      return false;
    }

    // Check if cell is occupied (but allow current piece positions)
    if (row >= 0 &&
        gameBoard[row][col] != null &&
        !positions.contains(position)) {
      return false;
    }

    return true;
  }

  bool isValidPiecePosition(List<int> piecePositions) {
    // Check if all positions are valid and piece doesn't wrap around edges
    for (int pos in piecePositions) {
      if (!positionIsValid(pos)) {
        return false;
      }
    }

    // Additional check to prevent pieces from wrapping around edges
    Set<int> columns = {};
    for (int pos in piecePositions) {
      columns.add(pos % rowCount);
    }

    // If piece spans both leftmost and rightmost columns, it's wrapping
    if (columns.contains(0) && columns.contains(rowCount - 1)) {
      return false;
    }

    return true;
  }

  // rotate piece
  /*   void rotatePiece() {
    if (type == TetrominoType.O) {
      // O piece does not rotate
      return;
    }
    List<List<int>> offsets = rotationOffsets[type]![rotationIndex];
    int anchor = positions[1];
    int anchorRow = (anchor / rowCount).floor();
    int anchorCol = anchor % rowCount;
    List<int> newPositions = [];

    for (final offset in offsets) {
      int newRow = anchorRow + offset[0];
      int newCol = anchorCol + offset[1];
      int newIndex = newRow * rowCount + newCol;
      newPositions.add(newIndex);
    }

    if (isValidPiecePosition(newPositions)) {
      positions = newPositions;
      rotationIndex = (rotationIndex + 1) % 4;
    }
  } */
  // void rotatePiece() {
  //   if (type == TetrominoType.O) return; // no rotation for O piece
  //   List<List<int>> offsets = rotationOffsets[type]![rotationIndex];
  //   int anchor = positions[1];
  //   int anchorRow = (anchor / rowCount).floor();
  //   int anchorCol = anchor % rowCount;
  //   List<int> newPositions = [];

  //   for (final offset in offsets) {
  //     int newRow = anchorRow + offset[0];
  //     int newCol = anchorCol + offset[1];
  //     int newIndex = newRow * rowCount + newCol;
  //     newPositions.add(newIndex);
  //   }

  //   if (isValidPiecePosition(newPositions)) {
  //     positions = newPositions;
  //     rotationIndex = (rotationIndex + 1) % 4;
  //   }
  // }

  // bool positionIsValid(int position) {
  //   int row = (position / rowCount).floor();
  //   int col = position % rowCount;
  //   if (row < 0 ||
  //       col < 0 ||
  //       col >= rowCount ||
  //       row >= columnCount ||
  //       (row >= 0 && gameBoard[row][col] != null)) {
  //     return false;
  //   }
  //   return true;
  // }

  // bool isValidPiecePosition(List<int> piecePositions) {
  //   bool firstColOccupied = false;
  //   bool lastColOccupied = false;
  //   for (int pos in piecePositions) {
  //     if (!positionIsValid(pos)) {
  //       return false;
  //     }
  //     int col = pos % rowCount;
  //     if (col == 0) firstColOccupied = true;
  //     if (col == rowCount - 1) lastColOccupied = true;
  //   }
  //   return !(firstColOccupied && lastColOccupied);
  // }
}
