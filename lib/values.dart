import 'package:flutter/material.dart';

int rows = 20;
int columns = 10;

enum Directions {
  left,
  right,
  down
}

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.I: Colors.red,
  Tetromino.J: Colors.black,
  Tetromino.L: Colors.purple,
  Tetromino.S: Colors.brown,
  Tetromino.Z: Colors.green,
  Tetromino.T: Colors.yellow,
  Tetromino.O: Colors.blue,
};