import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake/constants.dart';
import 'package:snake/screens/game_screen.dart';
import 'package:snake/screens/settings.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onWillPop() async {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to Exit the Application?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: Text('Yes'),
                  ),
                ],
              ));
    }

    final _random = new Random();
    var element = snakeIcons[_random.nextInt(snakeIcons.length)];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        return _onWillPop();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  height: context.responsive(150),
                  width: context.responsive(150),
                  child: Image.asset(
                    element,
                  ),
                ),
                SizedBox(
                  height: context.responsive(24),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GameScreen()));
                  },
                  child: Text(
                    'PLAY',
                    style: GoogleFonts.rubikGlitch(
                      fontSize: context.responsive(34),
                      color: Colors.green.shade200,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.responsive(24),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                  child: Text(
                    'SETTINGS',
                    style: GoogleFonts.rubikGlitch(
                      fontSize: context.responsive(34),
                      color: Colors.green.shade200,
                      letterSpacing: 3,
                      decorationThickness: 10,
                    ),
                  ),
                ),
                SizedBox(
                  height: context.responsive(24),
                ),
                Text(
                  'LEADERBOARD',
                  style: GoogleFonts.rubikGlitch(
                    fontSize: context.responsive(34),
                    color: Colors.green.shade200,
                    letterSpacing: 3,
                    decorationThickness: 10,
                  ),
                ),
                Spacer(),
                // Stack(
                //   children: [
                //     Column(
                //       children: [
                //         Text(
                //           'Created by Paul',
                //           style: GoogleFonts.actor(
                //             fontSize: context.responsive(18),
                //             color: Colors.white,
                //           ),
                //         ),
                //         SizedBox(
                //           height: context.responsive(12),
                //         ),
                //       ],
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
