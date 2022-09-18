import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:snake/constants.dart';
import 'package:snake/screens/homepage.dart';
import 'package:snake/widgets/food_pixel.dart';
import 'package:snake/widgets/grid_pixel.dart';
import 'package:snake/widgets/snake_pixel.dart';
import 'package:vibration/vibration.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _GameScreenState extends State<GameScreen> {
  final eatAudioPlayer = AssetsAudioPlayer();
  final moveAudioPlayer = AssetsAudioPlayer();
  final overAudioPlayer = AssetsAudioPlayer();
  late Timer tempTimer;

  late ConfettiController _controllerCenter;

  int rowSize = 20;
  int itemCount = 600;
  int currentScore = 0;
  int highScore = 0;
  bool gameHasStarted = false;

  var currentDirection = snake_Direction.RIGHT;

  List<int> snakePosition = [
    0,
    1,
    2,
  ];

  int foodPosition = 55;

  void startGame() async {
    gameHasStarted = true;
    Timer.periodic(
      Duration(milliseconds: 200),
      (timer) {
        tempTimer = timer;
        setState(
          () {
            moveSnake();
            if (gameOver()) {
              timer.cancel();
              alertDialog(context);
            }
          },
        );
      },
    );
  }

  void eatFood() {
    hasSound ? playEatingSound() : stopPlayer();
    currentScore++;
    while (snakePosition.contains(foodPosition)) {
      foodPosition = Random().nextInt(499);
    }
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
    tempTimer.cancel();
    Navigator.push(
        context, MaterialPageRoute(builder: ((context) => Homepage())));
    newGame();
  }

  pauseGame() {
    tempTimer = Timer.periodic(Duration(milliseconds: 0), (timer) {
      setState(() {});
    });
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
      snakePosition = [
        0,
        1,
        2,
      ];
      foodPosition = 55;
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

  void checkHighScore() {
    if (currentScore > highScore) {
      setState(() {
        highScore = currentScore;
      });
    }
  }

  playMovingSound() {
    moveAudioPlayer.open(
      Audio(
        'assets/sounds/move.mp3',
      ),
      pitch: 0.5,
      volume: 0.5,
    );
  }

  playEatingSound() {
    eatAudioPlayer.open(
      Audio('assets/sounds/eat.mp3'),
      volume: 0.5,
    );
  }

  playGameOverSound() {
    overAudioPlayer.open(
      Audio('assets/sounds/over.mp3'),
      volume: 0.5,
    );
  }

  stopPlayer() {
    moveAudioPlayer.stop();
    eatAudioPlayer.stop();
    overAudioPlayer.stop();
  }

  @override
  void initState() {
    startGame();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    super.initState();
  }

  @override
  void dispose() {
    startGame();
    moveAudioPlayer.dispose();
    eatAudioPlayer.dispose();
    overAudioPlayer.dispose();
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
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
                        return FooddPixel();
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

  Future<bool> _onWillPop() async {
    pauseGame();
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to quit the game??'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  startGame();
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
        )) ??
        false;
  }
}
