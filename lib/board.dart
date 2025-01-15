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
    
    int refreshRate = getTime(); 
    Duration frameRate = Duration(milliseconds: refreshRate);
    gameLoop(frameRate);
  }

  int getTime() {
    final random = Random();
    return 350 + random.nextInt(401);
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
      title: const Text('Koniec gry'),
      content: Text('Twój wynik to $currentScore'),
      actions: [
        TextButton(
          onPressed: () => {
            resetGame(),
            Navigator.pop(builder)
          },
          child: const Text('Zagraj ponownie'),
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
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  final double boardHeight = screenHeight * 0.75;
  final double boardWidth = screenWidth;

  final double pixelSizeByHeight = boardHeight / rows;

  final double currentBoardWidth = pixelSizeByHeight * columns;

  if (currentBoardWidth > screenWidth) {
    final double extraWidth = (currentBoardWidth - screenWidth) / 2;
    final double newPixelSize = (boardHeight - 2 * extraWidth) / rows;
    final double adjustedBoardWidth = newPixelSize * columns;

    final double horizontalSpacing = (screenWidth - adjustedBoardWidth) / (columns + 1);
    final double verticalSpacing = (boardHeight - newPixelSize * rows) / (rows - 1);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(160, 180, 132, 1),
      body: Column(
        children: [
          SizedBox(
            height: boardHeight,
            width: screenWidth,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: verticalSpacing,
                crossAxisSpacing: horizontalSpacing,
              ),
              itemCount: rows * columns,
              itemBuilder: (context, index) {
                int row = (index / columns).floor();
                int col = (index % columns);

                if (currentPice.positions.contains(index)) {
                  return Pixel(
                    color: currentPice.color,
                    pixelSize: newPixelSize, // Ustaw rozmiar pikseli
                  );
                } else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    color: tetrominoColors[tetrominoType],
                    pixelSize: newPixelSize,
                  );
                } else {
                  return Pixel(
                    color: const Color.fromRGBO(160, 180, 132, 1),
                    pixelSize: newPixelSize,
                  );
                }
              },
            ),
          ),
          Text(
            "Punkty: $currentScore",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(color: Colors.black, onPressed: rotatePiece, icon: const Icon(Icons.rotate_right)),
                IconButton(color: Colors.black, onPressed: moveLeft, icon: const Icon(Icons.arrow_back)),
                IconButton(color: Colors.black, onPressed: moveRight, icon: const Icon(Icons.arrow_forward)),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    final double pixelSize = pixelSizeByHeight;

    final double horizontalSpacing = (screenWidth - pixelSize * columns) / (columns - 1);
    final double verticalSpacing = (boardHeight - pixelSize * rows) / (rows - 1);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(160, 180, 132, 1),
      body: Column(
        children: [
          SizedBox(
            height: boardHeight,
            width: screenWidth,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: verticalSpacing,
                crossAxisSpacing: horizontalSpacing,
              ),
              itemCount: rows * columns,
              itemBuilder: (context, index) {
                int row = (index / columns).floor();
                int col = (index % columns);

                if (currentPice.positions.contains(index)) {
                  return Pixel(
                    color: currentPice.color,
                    pixelSize: pixelSize,
                  );
                } else if (gameBoard[row][col] != null) {
                  final Tetromino? tetrominoType = gameBoard[row][col];
                  return Pixel(
                    color: tetrominoColors[tetrominoType],
                    pixelSize: pixelSize,
                  );
                } else {
                  return Pixel(
                    color: const Color.fromRGBO(160, 180, 132, 1),
                    pixelSize: pixelSize,
                  );
                }
              },
            ),
          ),
          Text(
            "Punkty: $currentScore",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(color: Colors.black, onPressed: rotatePiece, icon: const Icon(Icons.rotate_right)),
                IconButton(color: Colors.black, onPressed: moveLeft, icon: const Icon(Icons.arrow_back)),
                IconButton(color: Colors.black, onPressed: moveRight, icon: const Icon(Icons.arrow_forward)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  }