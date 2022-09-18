import 'package:flutter/material.dart';

class SnakeHead extends StatelessWidget {
  const SnakeHead({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/snake_head.png',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}

class SnakeBody extends StatelessWidget {
  const SnakeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/snake_body.png',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}
