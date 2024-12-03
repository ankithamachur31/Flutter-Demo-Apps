import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TicTacToeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatelessWidget {
  const TicTacToeGame({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<TicTacToeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => gameProvider.makeMove(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: gameProvider.winningCombination.contains(index)
                        ? Colors.green
                        : Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      gameProvider.board[index],
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: gameProvider.board[index] == 'X' ? Colors.red : Colors.blue,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const Spacer(),
          if (gameProvider.winner != null || gameProvider.isBoardFull())
            Column(
              children: [
                Text(
                  gameProvider.winner != null
                      ? '${gameProvider.winner} Wins!'
                      : 'It\'s a Draw!',
                  style: const TextStyle(fontSize: 24),
                ),
                ElevatedButton(
                  onPressed: gameProvider.resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Restart Game'),
                ),
              ],
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class TicTacToeProvider extends ChangeNotifier {
  List<String> board = List.generate(9, (index) => '');
  String currentPlayer = 'X';
  String? winner;
  List<int> winningCombination = [];

  void makeMove(int index) {
    if (board[index] == '' && winner == null) {
      board[index] = currentPlayer;
      if (checkWinner()) {
        winner = currentPlayer;
      } else {
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }
      notifyListeners();
    }
  }

  bool checkWinner() {
    const winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == currentPlayer &&
          board[pattern[1]] == currentPlayer &&
          board[pattern[2]] == currentPlayer) {
        winningCombination = pattern;
        return true;
      }
    }
    return false;
  }

  bool isBoardFull() {
    return board.every((element) => element != '');
  }

  void resetGame() {
    board = List.generate(9, (index) => '');
    currentPlayer = 'X';
    winner = null;
    winningCombination = [];
    notifyListeners();
  }
}
