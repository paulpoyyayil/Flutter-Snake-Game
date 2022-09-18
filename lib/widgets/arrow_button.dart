import 'package:flutter/material.dart';
import 'package:snake/constants.dart';

class ArrowButtonWidget extends StatelessWidget {
  const ArrowButtonWidget({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: context.responsive(40),
      ),
    );
  }
}
