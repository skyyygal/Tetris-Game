import 'package:flutter/material.dart';
import 'package:tetris_game/game_board.dart';

import 'values.dart';

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

  // rotate piece

  void rotatePiece() {
    List<int> newPositions = [];

    switch (type) {
      case TetrominoType.L:
        switch (rotationIndex) {
          case 0:
            /*
          o
          o
          o o
          */
            //get the new position
            newPositions = [
              positions[1] - rowCount,
              positions[1],
              positions[1] + rowCount,
              positions[1] + rowCount + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            /*
          o o o
          o
          */
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + rowCount - 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            /*
          o o
            o
            o
          */
            newPositions = [
              positions[1] + rowCount,
              positions[1],
              positions[1] - rowCount,
              positions[1] - rowCount - 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            /*
              o
          o o o
          */
            newPositions = [
              positions[1] - rowCount + 1,
              positions[1],
              positions[1] + 1,
              positions[1] - 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      case TetrominoType.J:
        switch (rotationIndex) {
          case 0:

            /*
            o
            o
          o o
          */
            //get the new position
            newPositions = [
              positions[1] - rowCount,
              positions[1],
              positions[1] + rowCount,
              positions[1] + rowCount - 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            /*
          o
          o o o
          */
            newPositions = [
              positions[1] - rowCount - 1,
              positions[1],
              positions[1] - 1,
              positions[1] + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            /*
          o o
          o
          o
          */
            newPositions = [
              positions[1] + rowCount,
              positions[1],
              positions[1] - rowCount,
              positions[1] - rowCount + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] + rowCount + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      case TetrominoType.I:
        switch (rotationIndex) {
          case 0:
            //get the new position
            /*
            0 0 0 0
            */
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + 2,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            /*
            0 
            0 
            0
            0
            */
            newPositions = [
              positions[1] - rowCount,
              positions[1],
              positions[1] + rowCount,
              positions[1] + 2 * rowCount,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] - 2,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[1] + rowCount,
              positions[1],
              positions[1] - rowCount,
              positions[1] - 2 * rowCount,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      case TetrominoType.O:
        // O piece does not rotate
        break;
      // }
      case TetrominoType.S:
        /*
      0 0
    0 0
      */
        switch (rotationIndex) {
          case 0:
            //get the new position
            newPositions = [
              positions[1],
              positions[1] + 1,
              positions[1] + rowCount - 1,
              positions[1] + rowCount,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            /*
          o
          o o
            o
          */
            newPositions = [
              positions[0] - rowCount,
              positions[0],
              positions[0] + 1,
              positions[0] + rowCount + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            /*
      0 0
    0 0
      */
            newPositions = [
              positions[1],
              positions[1] + 1,
              positions[1] + rowCount - 1,
              positions[1] + rowCount,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            /*
          o
          o o
            o
          */
            newPositions = [
              positions[0] - rowCount,
              positions[0],
              positions[0] + 1,
              positions[0] + rowCount + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      case TetrominoType.Z:
        switch (rotationIndex) {
          case 0:
            /*
         o o
           o o
            
          */
            //get the new position
            newPositions = [
              positions[0] + rowCount - 2,
              positions[1],
              positions[2] + rowCount - 1,
              positions[3] + 1,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            newPositions = [
              positions[0] - rowCount + 2,
              positions[1],
              positions[2] - rowCount + 1,
              positions[3] - 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            newPositions = [
              positions[0] + rowCount - 2,
              positions[1],
              positions[2] + rowCount - 1,
              positions[3] + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[0] - rowCount + 2,
              positions[1],
              positions[2] - rowCount + 1,
              positions[3] - 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      case TetrominoType.T:
        switch (rotationIndex) {
          case 0:
            /*
          o
          o o
          o
          */
            //get the new position
            newPositions = [
              positions[2] - rowCount,
              positions[2],
              positions[2] + rowCount,
              positions[2] + rowCount,
            ];
            // check that this new position is a valid move before assigning it to the real position
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 1:
            /*
          o o o
            o
          */
            newPositions = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + rowCount,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 2:
            /*
            o
          o o
            o
          */
            newPositions = [
              positions[1] - rowCount,
              positions[1] - 1,
              positions[1],
              positions[1] + rowCount,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
          case 3:
            newPositions = [
              positions[2] - rowCount,
              positions[2] - 1,
              positions[2],
              positions[2] + 1,
            ];
            if (isValidPiecePosition(newPositions)) {
              positions = newPositions;
              rotationIndex = (rotationIndex + 1) % 4;
            }
            break;
        }
      default:
        break;
    }
  }
  /* 
  bool positionIsValid(int position) {
    int row = (position / rowCount).floor();
    int col = position % rowCount;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }
  // check if the piece is in valid position

  bool isValidPiecePosition(List<int> piecePositions) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;
    for (int pos in piecePositions) {
      if (positionIsValid(pos)) {
        return false;
      }
      // get the col of pos

      int col = pos % rowCount;
      // check if the first column is occupied
      if (col == 0) {
        firstColOccupied = true;
      }
      // check if the last column is occupied
      if (col == rowCount - 1) {
        lastColOccupied = true;
      }
    }
    //if there's a piece in the first and the last column, it's invalid
    return !(firstColOccupied && lastColOccupied);
  } */

  bool positionIsValid(int position) {
    int row = (position / rowCount).floor();
    int col = position % rowCount;
    if (row < 0 ||
        col < 0 ||
        col >= rowCount ||
        row >= columnCount ||
        (row >= 0 && gameBoard[row][col] != null)) {
      return false;
    }
    return true;
  }

  bool isValidPiecePosition(List<int> piecePositions) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;
    for (int pos in piecePositions) {
      if (!positionIsValid(pos)) {
        return false;
      }
      int col = pos % rowCount;
      if (col == 0) firstColOccupied = true;
      if (col == rowCount - 1) lastColOccupied = true;
    }
    return !(firstColOccupied && lastColOccupied);
  }
}
