
import 'package:untitled11/board.dart';
import 'package:untitled11/values.dart';
import 'package:flutter/material.dart';

class Pice {
  Tetromino type;

  Pice({required this.type});

  List<int> positions = [];

  Color get color {
    return tetrominoColors[type] ?? Colors.white;
  }

  void initializePiece() {
    switch (type) {
      case Tetromino.L:
        positions = [
          4 - 3*rows, 14 - 3*rows, 24 - 3*rows, 25 - 3*rows
        ];
        break;
      case Tetromino.J:
        positions = [
          5 - 3*rows, 15 - 3*rows, 25 - 3*rows, 24 - 3*rows
        ];
        break;
      case Tetromino.I:
        positions = [
          3 - rows, 4  - rows, 5 - rows, 6 - rows
        ];
        break;
      case Tetromino.O:
        positions = [
          4 - 2*rows, 5 - 2*rows, 14 - 2*rows, 15 - 2*rows
        ];
        break;
      case Tetromino.S:
        positions = [
          4 - 2*rows, 14 - 2*rows, 15 - 2*rows, 25 - 2*rows
        ];
        break;
      case Tetromino.Z:
        positions = [
          5 - 2*rows, 15 - 2*rows, 14 - 2*rows, 24 - 2*rows
        ];
        break;
      case Tetromino.T:
        positions = [
          4 - 2*rows, 14 - 2*rows, 24 - 2*rows, 15 - 2*rows
        ];
        break;
      default:
        positions = [];
    }
  }

  void movePiece(Directions direction) {
    switch (direction) {
      case Directions.down:
        for (int i = 0; i < positions.length; i++) {
          positions[i] += columns;
        }
        break;

      case Directions.left:
        for (int i = 0; i < positions.length; i++) {
          positions[i] -= 1;
        }
        break;
        
      case Directions.right:
        for (int i = 0; i < positions.length; i++) {
          positions[i] += 1;
        }
        break;
      default:
    }
  }

  int rotationState = 1;
  void rotatePiece() {
    List<int> newPosition = [];
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1] - columns,
              positions[1],
              positions[1] + columns,
              positions[1] + columns + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + columns - 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1] + columns,
              positions[1],
              positions[1] - columns,
              positions[1] - columns - 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] - columns + 1,
              positions[1],
              positions[1] + 1,
              positions[1] - 1
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1] - columns,
              positions[1],
              positions[1] + columns,
              positions[1] + columns - 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - columns - 1,
              positions[1],
              positions[1] - 1,
              positions[1] + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1] + columns,
              positions[1],
              positions[1] - columns,
              positions[1] - columns + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] + columns + 1
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.I:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + 2
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - columns,
              positions[1],
              positions[1] + columns,
              positions[1] + 2 * columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1] + 1,
              positions[1],
              positions[1] - 1,
              positions[1] - 2
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] + columns,
              positions[1],
              positions[1] - columns,
              positions[1] - 2 * columns
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;
        case Tetromino.O:
          break;
      case Tetromino.S:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1],
              positions[1] + 1,
              positions[1] + columns - 1,
              positions[1] + columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - columns,
              positions[1],
              positions[1] + 1,
              positions[1] + columns + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1],
              positions[1] + 1,
              positions[1] + columns - 1,
              positions[1] + columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] - columns,
              positions[1],
              positions[1] - 1,
              positions[1] + columns + 1
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1] + columns -2,
              positions[1],
              positions[1] + columns - 1,
              positions[1] + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - columns + 2,
              positions[1],
              positions[1] + columns + 1,
              positions[1] - 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1] + columns - 2,
              positions[1],
              positions[1] + columns - 1,
              positions[1] + 1
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] - columns + 2,
              positions[1],
              positions[1] - columns + 1,
              positions[1] - 1
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0: 
            newPosition = [
              positions[1] + columns - columns,
              positions[1],
              positions[1] + columns + 1,
              positions[1] + columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 1;
            }
            break;
          case 1:
            newPosition = [
              positions[1] - 1,
              positions[1],
              positions[1] + 1,
              positions[1] + columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 2;
            }
            break;
          case 2:
            newPosition = [
              positions[1] - columns,
              positions[1] - 1,
              positions[1],
              positions[1] + columns
            ];
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 3;
            }
            break;
          case 3:
            newPosition = [
              positions[1] - columns,
              positions[1] - 1,
              positions[1],
              positions[1] + 1
            ];
  
            if (picePositionIsValid(newPosition)) {
              positions = newPosition;
              rotationState = 0;
            }
            break;
        }
        break;

      default:
    }
  }

  bool positionIsValid(int position) {
    int row = (position/columns).floor();
    int col = position % columns;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

  bool picePositionIsValid(List<int> picePostion) {
    bool first = false;
    bool last = false;

    for (int pos in picePostion) {
      if (!positionIsValid(pos)) {
        return false;
      }

      int col = pos % columns;

      if (col == 0) {
        first = true;
      }

      if (col == columns - 1) {
        last = true;
      }
    }

    return !(first && last);
  }
}