import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Vipin Sharma 2018-2022 ',
          style: TextStyle(
            fontSize: 40.0,
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
