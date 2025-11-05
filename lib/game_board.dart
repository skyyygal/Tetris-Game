import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'piece.dart';
import 'utils.dart';

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
  // Random random = Random();
  // Piece currentPiece = Piece(type: TetrominoType.values.first);
  late Piece currentPiece;
  Timer? timer;
  int currentScore = 0;
  int highScore = 0;

  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void checkGameOver() {
    if (isGameOver()) {
      updateHighScore();
      showGameOverDialog(context);
      timer?.cancel();
    }
  }

  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  Future<void> updateHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentScore > highScore) {
      setState(() {
        highScore = currentScore;
      });
      prefs.setInt('highScore', highScore);
    }
  }

  void startGame() {
    Random random = Random();

    // Generate a random TetrominoType for the first piece
    TetrominoType randomType =
        TetrominoType.values[random.nextInt(TetrominoType.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
    Duration frameRate = Duration(milliseconds: 600);
    gameLoop(frameRate);
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
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.redAccent, width: 2),
          ),
          title: Text(
            'Game Over',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Score: $currentScore',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.greenAccent, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    resetGame();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restart_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Play Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    Color.fromARGB(255, 77, 65, 65);
    setState(() {
      gameBoard = List.generate(
        columnCount,
        (i) => List.generate(rowCount, (j) => null),
      );
      currentScore = 0;
      gameOver = false;
      createNewPiece();
    });
    startGame();
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
      if (isGameOver()) {
        // gameOver = true;
        timer?.cancel();
        showGameOverDialog(context);
      } else {
        createNewPiece();
      }
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

  void moveDownOne() {
    if (!checkCollision(Direction.down)) {
      setState(() {
        currentPiece.movePiece(Direction.down);
      });
    } else {
      checkLanding();
    }
  }

  void moveDownTwo() {
    for (int i = 0; i < 2; i++) {
      if (!checkCollision(Direction.down)) {
        setState(() {
          currentPiece.movePiece(Direction.down);
        });
      } else {
        checkLanding();
        break;
      }
    }
  }

  void hardDrop() {
    while (!checkCollision(Direction.down)) {
      setState(() {
        currentPiece.movePiece(Direction.down);
      });
    }
    checkLanding();
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
    // check if any column in the top row is filled
    for (int col = 0; col < rowCount; col++) {
      if (gameBoard[0][col] != null) {
        // gameOver = true;
        return true;
      }
    }
    // If the top row is empty, the game is not over
    return false;
  }

  /*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Minimal Header
              _buildHeader(),
              SizedBox(height: 20),

              // Flexible Game Board that won't overflow
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey[800]!, width: 3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowCount,
                      ),
                      itemCount: rowCount * columnCount,
                      itemBuilder: (context, index) {
                        int row = (index / rowCount).floor();
                        int col = index % rowCount;

                        if (currentPiece.positions.contains(index)) {
                          return _buildGameCell(
                            color: currentPiece.color,
                            hasBorder: true,
                            isActive: true,
                          );
                        } else if (gameBoard[row][col] != null) {
                          return _buildGameCell(
                            color: tetrominoColors[gameBoard[row][col]]!,
                            hasBorder: false,
                            isActive: false,
                          );
                        } else {
                          return _buildGameCell(
                            color: Colors.grey[800]!,
                            hasBorder: false,
                            isActive: false,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Compact Game Controls with Down Button
              _buildGameControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "TETRIS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 75, 54, 17),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "High Score: $currentScore",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Score: $currentScore",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCell({
    required Color color,
    required bool hasBorder,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: hasBorder
            ? Border.all(color: Colors.white.withOpacity(0.8), width: 1)
            : null,
      ),
    );
  }

  Widget _buildGameControls() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rotate Button
          _buildControlButton(
            onPressed: rotatePiece,
            icon: Icons.rotate_right,
            color: Colors.orange[700]!,
            size: 60,
          ),

          SizedBox(height: 16),

          // Direction Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                onPressed: moveLeft,
                icon: Icons.arrow_left,
                color: Colors.blue[700]!,
                size: 60,
              ),

              _buildControlButton(
                onPressed: moveDownOne,
                icon: Icons.arrow_drop_down,
                color: Colors.red[700]!,
                size: 60,
              ),

              _buildControlButton(
                onPressed: moveRight,
                icon: Icons.arrow_right,
                color: Colors.blue[700]!,
                size: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        color: Colors.white,
        icon: Icon(icon, size: size * 0.5),
      ),
    );
  }
}
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header with Music Control
              _buildHeader(),
              SizedBox(height: 20),

              // Flexible Game Board
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey[800]!, width: 3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowCount,
                      ),
                      itemCount: rowCount * columnCount,
                      itemBuilder: (context, index) {
                        int row = (index / rowCount).floor();
                        int col = index % rowCount;

                        if (currentPiece.positions.contains(index)) {
                          return _buildGameCell(
                            color: currentPiece.color,
                            hasBorder: true,
                            isActive: true,
                          );
                        } else if (gameBoard[row][col] != null) {
                          return _buildGameCell(
                            color: tetrominoColors[gameBoard[row][col]]!,
                            hasBorder: false,
                            isActive: false,
                          );
                        } else {
                          return _buildGameCell(
                            color: Colors.grey[800]!,
                            hasBorder: false,
                            isActive: false,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Game Controls
              _buildGameControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "TETRIS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          // Music Control
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  "High Score : $highScore",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Score: $currentScore",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCell({
    required Color color,
    required bool hasBorder,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: hasBorder
            ? Border.all(color: Colors.white.withOpacity(0.8), width: 1)
            : null,
      ),
    );
  }

  Widget _buildGameControls() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rotate Button
          _buildControlButton(
            onPressed: rotatePiece,
            icon: Icons.rotate_right,
            color: Colors.orange[700]!,
            size: 60,
          ),

          SizedBox(height: 16),

          // Direction Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                onPressed: moveLeft,
                icon: Icons.arrow_left,
                color: Colors.blue[700]!,
                size: 60,
              ),

              _buildControlButton(
                onPressed: moveDownOne,
                icon: Icons.arrow_drop_down,
                color: Colors.red[700]!,
                size: 60,
              ),

              _buildControlButton(
                onPressed: moveRight,
                icon: Icons.arrow_right,
                color: Colors.blue[700]!,
                size: 60,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        color: Colors.white,
        icon: Icon(icon, size: size * 0.5),
      ),
    );
  }
}
