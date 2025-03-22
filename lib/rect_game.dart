import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.icon});

  final IconData icon;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<bool> _visibleRectagles = List.generate(25, (index) => false);
  final Set<int> oldRectangles = {};
  int currentIndex = 0;
  int totalIndex = 0;
  bool gameStarted = false;
  int gameTime = 0;
  bool isGameFinishedTime = false;
  Timer? timer;

  void startGame() {
    setState(() {
      totalIndex = 0;
      oldRectangles.clear();
      currentIndex = indexGenerator();
      _visibleRectagles[currentIndex] = true;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          gameTime++;
        });
      });
    });
  }

  int indexGenerator() {
    Random random = Random();
    int newIndex;
    do {
      newIndex = random.nextInt(25);
    } while (newIndex == currentIndex || oldRectangles.contains(newIndex));
    return newIndex;
  }

  void rectangleClicked(int index) {
    if (oldRectangles.contains(index)) {
      endGame(
          messege: 'You lost the game',
          title: 'time taken: ${gameTime.toString()}s');
    } else if (!oldRectangles.contains(index)) {
      setState(() {
        currentIndex = index;
        // _visibleRectagles[currentIndex] = true;
        totalIndex++;
        oldRectangles.add(index);

        if (totalIndex > 23 /* or i can use totalIndex >=24*/) {
          endGame(
              title: 'Congratulations',
              messege: 'Your won the game and clicked all the rectangles');
        } else {
          currentIndex = indexGenerator();
          _visibleRectagles[currentIndex] = true;
          // do the new rects visible
        }
      });
    } else {
      endGame(messege: 'You lost the game', title: gameTime.toString());
    }
  }

  void endGame({String? messege, String? title}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title!),
        content: Text(messege!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
              timer!.cancel();
              isGameFinishedTime = true;
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    totalIndex = 0;
    oldRectangles.clear();
    _visibleRectagles = List.generate(25, (index) => false);
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rectangle Game'),
        ),
        body: Stack(
          children: [
            gameStarted
                ? Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Colors.deepPurple[100],
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4, // 5 columns for the 5x5 grid
                            ),
                            itemCount: 24,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (_visibleRectagles[index]) {
                                    rectangleClicked(index);
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1),
                                    ),
                                  ),
                                  child: _visibleRectagles[index]
                                      ? Opacity(
                                          opacity: 1,
                                          child: Icon(widget.icon),
                                        )
                                      : Opacity(
                                          opacity: 0,
                                          child: Icon(widget.icon),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Expanded(
                        child:
                            Text('Click the new icons that randomly appears'),
                      )
                    ],
                  )
                : Expanded(
                    child: Container(
                      color: Colors.deepPurple,
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              startGame();
                              gameStarted = true;
                            });
                          },
                          child: const Text(
                            'Start the game',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }
}


class SelectRectangleShape extends StatelessWidget {
  const SelectRectangleShape({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [
      Icons.home,
      Icons.star,
      Icons.favorite,
      Icons.person,
      Icons.settings,
      Icons.search,
      Icons.notifications,
      Icons.camera_alt,
      Icons.map,
      Icons.phone,
      Icons.email,
      Icons.shopping_cart,
      Icons.lock,
      Icons.calendar_today,
      Icons.music_note,
      Icons.cloud,
      Icons.build,
      Icons.chat,
      Icons.directions_car,
      Icons.flight,
      Icons.book,
      Icons.computer,
      Icons.headset,
      Icons.local_cafe,
      Icons.sports_soccer,
    ];

    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: Text('select the icon to play with')),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: iconList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                GameScreen(icon: iconList[index])));
                  },
                  child: Container(
                    decoration: BoxDecoration(border: Border.all()),
                    child: Icon(
                      iconList[index],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
