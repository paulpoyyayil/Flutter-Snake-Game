import 'package:flutter/material.dart';

class GridPixel extends StatelessWidget {
  const GridPixel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
