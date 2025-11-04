import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'piece.dart';
import 'pixel.dart';
import 'values.dart';

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
  Piece currentPiece = Piece(type: TetrominoType.values.first);
  Timer? timer;
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    Duration frameRate = Duration(milliseconds: 800);
    gameLoop(frameRate);
    // currentPiece = Piece(type: TetrominoType.values.first)..initializePiece();
    // const frameRate = Duration(milliseconds: 800);
    // timer = Timer.periodic(frameRate, (timer) {
    //   setState(() {
    //     clearLines();
    //     checkLanding();
    //     currentPiece.movePiece(Direction.down);
    //   });
    // });
  }

  void gameLoop(Duration frameRate) {
    timer = Timer.periodic(frameRate, (timer) {
      setState(() {
        clearLines();
        checkLanding();
        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog(context);
        }
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // game over message
  void showGameOverDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your final score is: $currentScore'),
        actions: <Widget>[
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      // Reset the game board
      gameBoard = List.generate(
        columnCount,
        (i) => List.generate(rowCount, (j) => null),
      );
      currentScore = 0;
      gameOver = false;
      createNewPiece();
      startGame();
    });
  }

  bool checkCollision(Direction direction) {
    for (int pos in currentPiece.positions) {
      int row = (pos / rowCount).floor();
      int col = pos % rowCount;

      switch (direction) {
        case Direction.left:
          col -= 1;
          break;
        case Direction.right:
          col += 1;
          break;
        case Direction.down:
          row += 1;
          break;
      }

      if (row >= columnCount || col < 0 || col >= rowCount) {
        return true;
      }
      if (row >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int pos in currentPiece.positions) {
        int row = (pos / rowCount).floor();
        int col = pos % rowCount;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      createNewPiece();
    }
  }

  void createNewPiece() {
    Random random = Random();
    TetrominoType tetrominoRandomType =
        TetrominoType.values[random.nextInt(TetrominoType.values.length)];
    currentPiece = Piece(type: tetrominoRandomType)..initializePiece();
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    //step 1: Loop through each row of the game board from bottom to top
    for (int row = columnCount - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;
      // step 3: Check if the row is full(all columns in the row are filled with pieces)
      for (int col = 0; col < rowCount; col++) {
        // if there's an empty col, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }
      //step 4: if the row is full, clear the row and shift the rows down
      if (rowIsFull) {
        //step 5 : move all rows above the cleared row down by position
        for (int r = row; r > 0; r--) {
          //copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        //step 6: set the top row to empty
        gameBoard[0] = List.generate(rowCount, (index) => null);
        //step 7: increase the score!
        currentScore++;
      }
    }
  }

  bool isGameOver() {
    gameOver = true;
    // check if any column in the top row is filled
    for (int col = 0; col < rowCount; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    // If the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowCount,
              ),
              itemCount: rowCount * columnCount,
              itemBuilder: (context, index) {
                int row = (index / rowCount).floor();
                int col = index % rowCount;

                if (currentPiece.positions.contains(index)) {
                  return Pixel(color: currentPiece.color, child: index);
                } else if (gameBoard[row][col] != null) {
                  return Pixel(
                    color: tetrominoColors[gameBoard[row][col]]!,
                    child: index,
                  );
                } else {
                  return Pixel(color: Colors.grey[900]!, child: index);
                }
              },
            ),
          ),
          Text(
            "Score: $currentScore",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          //Game Controls
          Padding(
            padding: const EdgeInsets.only(bottom: 50, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    moveLeft();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.arrow_left),
                ),
                IconButton(
                  onPressed: () {
                    rotatePiece();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.rotate_right),
                ),
                IconButton(
                  onPressed: () {
                    moveRight();
                  },
                  color: Colors.white,
                  icon: Icon(Icons.arrow_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
