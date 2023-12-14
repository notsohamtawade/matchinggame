import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matching Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MatchingGame(),
    );
  }
}

class MatchingGame extends StatefulWidget {
  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  List<String> images = [
    'assets/emotion1.png',
    'assets/emotion2.png',
    'assets/emotion3.png',
    'assets/emotion4.png',
    'assets/emotion5.png',
    'assets/emotion6.png',
  ];

  List<String> shuffledImages = [];
  List<bool> flipped = [];
  bool isBusy = false;
  int previousIndex = -1;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    images.addAll(images); // Duplicate the images for matching pairs
    images.shuffle();
    flipped = List<bool>.generate(images.length, (index) => false);
  }

  void resetGame() {
    setState(() {
      initializeGame();
      previousIndex = -1;
      currentIndex = -1;
      isBusy = false;
    });
  }

  void checkMatch(int index) {
    if (isBusy || flipped[index]) {
      return;
    }

    setState(() {
      flipped[index] = true;

      if (previousIndex == -1) {
        previousIndex = index;
      } else {
        if (images[previousIndex] != images[index]) {
          isBusy = true;
          Timer(Duration(seconds: 1), () {
            setState(() {
              flipped[previousIndex] = false;
              flipped[index] = false;
              previousIndex = -1;
              isBusy = false;
            });
          });
        } else {
          previousIndex = -1;
        }
      }

      if (!flipped.contains(false)) {
        // All cards are flipped, game over
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have matched all the pairs.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  resetGame();
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matching Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              checkMatch(index);
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: flipped[index]
                  ? Image.asset(images[index])
                  : Image.asset('assets/cover.png'), // Use a placeholder image or color for the back of the card
            ),
          );
        },
      ),
    );
  }
}
