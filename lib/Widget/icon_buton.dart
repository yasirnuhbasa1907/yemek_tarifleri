import 'package:flutter/material.dart';

class IconButon extends StatelessWidget {
  final IconData icon;
  final VoidCallback pressed;


  const IconButon({super.key, required this.icon, required this.pressed});

  @override
  Widget build(BuildContext context) {
    return  IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        fixedSize: const Size(50, 50)
      ),
      onPressed: pressed,
      icon: Icon(icon),
    );
  }
}