import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

/*
Game Board Widget
this is 2/2 grid with null representing an empty space
and a number representing a filled space.
A non empty space will have a color represent the landed pieces
*/
//Create a game board
List<List<TetrominoType?>> gameBoard = List.generate(
  columnCount,
  (i) => List.generate(rowCount, (j) => null),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: TetrominoType.L);
  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 900);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        //check for landing
        checkLanding();
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  //check for the collision in a future position
  //return true -> collision detected
  //return false -> no collision

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.positions.length; i++) {
      int row = (currentPiece.positions[i] / rowCount).floor();
      int col = currentPiece.positions[i] % rowCount;

      switch (direction) {
        case Direction.left:
          col -= 1;
          // if (column == 0) {
          //   return true;
          // }
          break;
        case Direction.right:
          col += 1;
          // if (column == rowCount - 1) {
          //   return true;
          // }
          break;
        case Direction.down:
          row += 1;
          // if (row == columnCount - 1) {
          //   return true;
          // }
          break;
      }
      // check if the piece is out of bounds
      if (row >= columnCount || col < 0 || col >= rowCount) {
        return true;
      }
      //if not collisions are detected, return false
    }
    return false;
  }

  void checkLanding() {
    //if going down is occupied, then land the piece
    if (checkCollision(Direction.down)) {
      //land the piece
      //generate a new piece
      for (int i = 0; i < currentPiece.positions.length; i++) {
        //add the piece to the board
        //occupiedPositions.add(currentPiece.positions[i]);

        int row = (currentPiece.positions[i] / rowCount).floor();
        int col = currentPiece.positions[i] % rowCount;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    //create a new random piece
    Random random = Random();
    TetrominoType randomType =
        TetrominoType.values[random.nextInt(TetrominoType.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: 1000,
        width: 500,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: rowCount,
          ),
          itemCount: rowCount * columnCount,
          // physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //randomly color the pixels
            Random random = Random();
            //get the row and column of each index
            int row = (index / rowCount).floor();
            int col = index % rowCount;
            //current piece
            if (currentPiece.positions.contains(index)) {
              print("index.toString(): ${index.toString()}");
              return Pixel(color: Colors.yellow, child: index);
            } else if (gameBoard[row][col] != null) {
              //landed pieces

              return Pixel(color: Colors.red, child: index);
            } else {
              //blank pixels
              return Pixel(color: Colors.grey[900], child: index);
            }
          },
        ),
      ),
    );
  }
}
