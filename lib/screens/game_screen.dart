import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snake/constants.dart';
import 'package:snake/screens/homepage.dart';
import 'package:snake/widgets/food_pixel.dart';
import 'package:snake/widgets/grid_pixel.dart';
import 'package:snake/widgets/snake_pixel.dart';
import 'package:vibration/vibration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _GameScreenState extends State<GameScreen> {
  late Timer snakeTimer;
  late ConfettiController _controllerCenter;
  late AudioPlayer _audioPlayer;

  int rowSize = 20;
  int itemCount = 600;
  int currentScore = 0;
  int highScore = 0;
  bool gameHasStarted = false;

  var currentDirection = snake_Direction.RIGHT;

  List<int> snakePosition = [0, 1, 2];

  int foodPosition = -1;

  void startGame() async {
    gameHasStarted = true;
    snakeTimer = Timer.periodic(
      Duration(milliseconds: 200),
      (timer) {
        if (mounted) {
          setState(
            () {
              moveSnake();
              if (gameOver()) {
                timer.cancel();
                alertDialog(context);
              }
            },
          );
        }
      },
    );
  }

  void eatFood() {
    hasSound ? playEatingSound() : stopPlayer();
    currentScore++;
    placeFood();
  }

  void placeFood() {
    List<int> availablePositions = List.generate(itemCount, (index) => index)
      ..removeWhere((pos) => snakePosition.contains(pos));
    foodPosition =
        availablePositions[Random().nextInt(availablePositions.length)];
  }

  bool gameOver() {
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);

    if (bodySnake.contains(snakePosition.last)) {
      hasVibration ? Vibration.vibrate() : null;
      hasSound ? playGameOverSound() : stopPlayer();
      stopPlayer();
      checkHighScore();
      return true;
    } else if (wonGame()) {
      return true;
    }
    return false;
  }

  stopGame() {
    snakeTimer.cancel();
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Homepage())));
    newGame();
  }

  void pauseGame() {
    snakeTimer.cancel();
  }

  void resumeGame() {
    snakeTimer = Timer.periodic(
      Duration(milliseconds: 200),
      (timer) {
        if (mounted) {
          setState(() {
            moveSnake();
            if (gameOver()) {
              timer.cancel();
              alertDialog(context);
            }
          });
        }
      },
    );
  }

  alertDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text('GAME OVER'),
            content: Text('Your score is: $currentScore'),
            actions: [
              MaterialButton(
                color: Colors.pink,
                child: Text('Ok'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Homepage())));
                  newGame();
                },
              )
            ],
          );
        }));
  }

  bool wonGame() {
    if (snakePosition.length == itemCount) {
      confetti();
      return true;
    }
    return false;
  }

  Widget confetti() {
    return ConfettiWidget(
      confettiController: _controllerCenter,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: true,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple
      ],
    );
  }

  void newGame() {
    setState(() {
      snakePosition = [0, 1, 2];
      placeFood();
      currentDirection = snake_Direction.RIGHT;
      gameHasStarted = false;
      currentScore = 0;
    });
  }

  void moveSnake() {
    hasSound ? playMovingSound() : stopPlayer();
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePosition.last % rowSize == 19) {
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }
        break;
      case snake_Direction.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition.add(snakePosition.last - rowSize + itemCount);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }
        break;
      case snake_Direction.DOWN:
        {
          if (snakePosition.last + rowSize > itemCount) {
            snakePosition.add(snakePosition.last + rowSize - itemCount);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }
        break;
    }
    if (snakePosition.last == foodPosition) {
      eatFood();
    } else {
      snakePosition.removeAt(0);
    }
  }

  void checkHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (currentScore > highScore) {
      setState(() {
        highScore = currentScore;
      });
      prefs.setInt('highScore', highScore);

      // Show input dialog to enter name
      TextEditingController nameController = TextEditingController();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('New High Score!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Congratulations! You set a new high score!'),
              SizedBox(height: 14),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String playerName = nameController.text;
                if (playerName.isNotEmpty) {
                  saveHighScoreToFirestore(playerName, currentScore);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }
  }

// Function to save high score to Firestore
  void saveHighScoreToFirestore(String name, int score) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final faker = Faker();
    String randomName = faker.person.name();

    await firestore.collection('high_scores').add({
      'name': name.isEmpty ? randomName : name,
      'score': score,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void playMovingSound() async {
    // if (hasSound) {
    //   await _audioPlayer.play(AssetSource('sounds/move.mp3'));
    // }
  }

  void playEatingSound() async {
    if (hasSound) {
      await _audioPlayer.play(AssetSource('sounds/eat.mp3'));
    }
  }

  void playGameOverSound() async {
    if (hasSound) {
      await _audioPlayer.play(AssetSource('sounds/over.mp3'));
    }
  }

  stopPlayer() async {
    await _audioPlayer.stop();
  }

  @override
  void initState() {
    placeFood();
    loadHighScore();
    startGame();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    startGame();
    _controllerCenter.dispose();
    super.dispose();
  }

  void loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = (prefs.getInt('highScore') ?? 0); // Load saved high score
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        return _onWillPop();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Current Score'),
                      Text(
                        currentScore.toString(),
                        style: TextStyle(fontSize: context.responsive(36)),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('High Score'),
                      Text(
                        highScore.toString(),
                        style: TextStyle(fontSize: context.responsive(36)),
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Container(
                child: GestureDetector(
                  onVerticalDragUpdate: ((details) {
                    if (details.delta.dy > 0 &&
                        currentDirection != snake_Direction.UP) {
                      currentDirection = snake_Direction.DOWN;
                    } else if (details.delta.dy < 0 &&
                        currentDirection != snake_Direction.DOWN) {
                      currentDirection = snake_Direction.UP;
                    }
                  }),
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snake_Direction.LEFT) {
                      currentDirection = snake_Direction.RIGHT;
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snake_Direction.RIGHT) {
                      currentDirection = snake_Direction.LEFT;
                    }
                  },
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: itemCount,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: rowSize),
                    itemBuilder: ((context, index) {
                      if (snakePosition.contains(index)) {
                        if (index == snakePosition.last) {
                          return SnakeHead();
                        } else {
                          return SnakeBody();
                        }
                      } else if (foodPosition == index) {
                        return FoodPixel();
                      } else {
                        return GridPixel();
                      }
                    }),
                  ),
                ),
              ),
              Spacer(),
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            hasVibration == true
                                ? hasVibration = false
                                : hasVibration = true;
                          }),
                          child: ImageIcon(
                            hasVibration
                                ? AssetImage(
                                    'assets/vibrate_on.png',
                                  )
                                : AssetImage('assets/vibrate_off.png'),
                            size: context.responsive(25),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            hasSound == true
                                ? hasSound = false
                                : hasSound = true;
                          },
                          child: Icon(
                            hasSound ? Icons.volume_down : Icons.volume_off,
                            size: context.responsive(30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _onWillPop() async {
    pauseGame();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to quit the game??'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              resumeGame();
              Navigator.of(context).pop(false);
            },
            child: new Text('No'),
          ),
          TextButton(
            onPressed: stopGame,
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }
}
