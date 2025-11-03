import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: rowCount,
        ),
        itemCount: rowCount * columnCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (currentPiece.positions.contains(index)) {
            print("index.toString(): ${index.toString()}");
            return Pixel(color: Colors.yellow, child: index);
          } else {
            return Pixel(color: Colors.grey[900], child: index);
          }
        },
      ),
    );
  }
}
