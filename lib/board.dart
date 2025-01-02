import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled11/pixel.dart';
import 'package:untitled11/pice.dart';
import 'package:untitled11/values.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

List<List<Tetromino?>> gameBoard = List.generate(rows, (i) => List.generate(columns, (j) => null));

class _GameBoardState extends State<GameBoard> {
  Pice currentPice = Pice(type: Tetromino.L);
  int currentScore = 0;
  bool theEnd = false;

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    // currentPice = getRandomPice();
    currentPice.initializePiece();

    Duration frameRate = const Duration(milliseconds: 150);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {
          tetris();

          if (theEnd) {
            timer.cancel();
            resultsDialog();
          }

          checkLanding();
          currentPice.movePiece(Directions.down);
        });
      }
    );
  }

  bool end() {
    for (int i = 0; i<columns; i++) {
      if (gameBoard[0][i] != null) {
        return true;
      }
    }
    return false;
  }

  void resultsDialog() {
    showDialog(context: context, builder: (builder) => AlertDialog(
      title: Text('Koniec gry'),
      content: Text('Twój wynik to ${currentScore}'),
      actions: [
        TextButton(
          onPressed: () => {
            resetGame(),
            Navigator.pop(builder)
          },
          child: Text('Zagraj ponownie'),
        )
      ],
    ));
  }

  void resetGame() {
    gameBoard = List.generate(rows, (i) => List.generate(columns, (j) => null));
    theEnd = false;
    currentScore = 0;
    createNewPice();
    startGame();
  }

  Pice getRandomPice() { 
    Random rand = Random();
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    return Pice(type: randomType);
  }

  void tetris() {
    for (int row = rows - 1; row >= 0; row--) {
      bool full = true;

      for (int col = 0; col < columns; col++) {
        if (gameBoard[row][col] == null) {
          full = false;
          break;
        }
      }
      
      if (full) {
        for (int r = row; r>0; r--) {
          gameBoard[r] = List.from(gameBoard[r-1]);
        }

        gameBoard[0] = List.generate(row, (index) => null);

        currentScore++;
      }

    }

  }

  bool colisionDetector(Directions direction) {
    for (int i = 0; i<currentPice.positions.length; i++) {
      int row = (currentPice.positions[i] / columns).floor();
      int col = (currentPice.positions[i] % columns);

      if (direction == Directions.left) {
        col -= 1;
      } else if (direction == Directions.right) {
        col += 1;
      } else if (direction == Directions.down) {
        row += 1;
      }
      
      if (row >= rows || col < 0 || col >= columns) {
        return true;
      } else if (col > 0 && row > 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  void checkLanding() {
    if (colisionDetector(Directions.down)) {
      for (int i = 0; i < currentPice.positions.length; i++) {
        int row = (currentPice.positions[i] / columns).floor();
        int col = (currentPice.positions[i] % columns);
        if (row >= 0 && col >= 0 && row < rows + 1 && col < columns + 1) {
          gameBoard[row][col] = currentPice.type;
        }
      }
      createNewPice();
    }
  }

  void createNewPice() {
    Random rand = Random();
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPice = Pice(type: randomType);
    currentPice.initializePiece();

    if (end()) {
     theEnd = true;
    }
  }

  void moveLeft() {
    if (!colisionDetector(Directions.left)) {
      setState(() {
        currentPice.movePiece(Directions.left);
      });
    }
  }

  void moveRight() {
    if (!colisionDetector(Directions.right)) {
      setState(() {
        currentPice.movePiece(Directions.right);
      });
    }
  }

  void rotatePiece() {
    currentPice.rotatePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(160,180,132,1),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: rows * columns,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns),
              itemBuilder: (context, index) {
                int row = (index / columns).floor();
                int col = (index % columns);
                if (currentPice.positions.contains(index)) {
                  return Pixel(
                    color: currentPice.color, 
                    child: index,
                  );
                } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(color: tetrominoColors[tetrominoType], child: '');
                } else {
                   return Pixel(
                    color: Color.fromRGBO(160,180,132,1), 
                    child: index,
                  );
                }
              } 
            ),
          ),
          Text(
            "Punkty: ${currentScore}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(color:Colors.black, onPressed: rotatePiece, icon: Icon(Icons.rotate_right)),
                IconButton(color:Colors.black, onPressed: moveLeft, icon: Icon(Icons.arrow_back)),
                IconButton(color:Colors.black, onPressed: moveRight, icon: Icon(Icons.arrow_forward)),
              ],
            ),
          )
        ],
      ),
    );
  }
}