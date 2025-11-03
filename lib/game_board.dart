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

  // bool checkCollision(Direction direction) {}
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
