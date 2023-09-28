import 'package:flutter/material.dart';

class TodayInfo extends StatelessWidget {
  const TodayInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
      child: Text(
        "TODAY : Sep 28, 2023",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
