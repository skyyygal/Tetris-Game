import 'dart:ui';

int rowCount = 10;
int columnCount = 13;

enum TetrominoType { I, O, T, S, Z, J, L }

enum Direction { left, right, down }

const Map<TetrominoType, Color> tetrominoColors = {
  TetrominoType.I: Color(0xFF00FFFF), // Cyan
  TetrominoType.O: Color(0xFFFFFF00), // Yellow
  TetrominoType.T: Color(0xFF800080), // Purple
  TetrominoType.S: Color(0xFF00FF00), // Green
  TetrominoType.Z: Color(0xFFFF0000), // Red
  TetrominoType.J: Color(0xFF0000FF), // Blue
  TetrominoType.L: Color(0xFFFFA500), // Orange
};
